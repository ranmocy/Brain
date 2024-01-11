#!/usr/bin/env -S node --experimental-module
// Run with `.scripts/build.mjs`
// node = v18.18.2

import path from 'path'
import fs from 'fs'
import { fileURLToPath } from 'url';
import assert from 'assert';
import showdown from './showdown.min.js'

const __filename = fileURLToPath(import.meta.url);
const ROOT_DIR = path.join(__filename, '../../')
const BUILD_DIR = path.join(ROOT_DIR, '.build')
const PUBLIC_DIR = path.join(ROOT_DIR, '.public')
const TEMPLATES_DIR = path.join(ROOT_DIR, '.templates')

const TITLE = "Ranmocy's Garden"
const TAGLINE = "My Brain, My Treasure"
const GROUPS = {
  life: ["diary", "dream", "poem", "novel"],
  thought: ["remark", "philosophy"],
  work: ["tech", "project", "translation"],
}
const CATEGORIES = Object.values(GROUPS).flat()
const CATEGORY_TAGLINES = {
  diary: "一个欲望灼烧者艰难写下的自白",
  dream: "最真实总是梦境",
  poem: "用诗歌来拯救自我",
  novel: "名为故事的脑中的影像",
  remark: "诸事皆可总结，万物皆可抽象",
  philosophy: "我在教导你们世界运行的原动力。你们听之，想之，就忘之吧",
  tech: "技术宅拯救世界",
  project: "What I did defines what I am",
  translation: "Words worth spreading widely",
}

const MARKDOWN_CONVERTER = new showdown.Converter()


// Cleanup built dir
if (fs.existsSync(BUILD_DIR)) {
  fs.rmSync(BUILD_DIR, { recursive: true })
}
fs.mkdirSync(BUILD_DIR)


// Read all files
const filesByCategory = Object.fromEntries(CATEGORIES.map((category) => {
  const categoryPath = path.join(ROOT_DIR, category)

  const files = fs.readdirSync(categoryPath)
    .filter((filename) => filename.endsWith('.md'))
    .map((filename) => {
      const filePath = path.join(categoryPath, filename)
      const fileContent = fs.readFileSync(filePath, { encoding: 'utf-8' })
      // ---
      // key: value
      // ---
      //
      // body
      const contentParts = fileContent.split("\n---\n\n")
      assert(contentParts.length === 2, filePath)
      const [headerLines, content] = contentParts

      // Extract headers
      const headers = Object.fromEntries(
        headerLines.split("\n").slice(1)
          .map(line => line.split(': '))
          .filter(parts => parts.length >= 2)
          .map(parts => {
            let value = parts.slice(1).join(': ')
            // Remove excaping in values
            if (value[0] === '"' && value[value.length - 1] === '"') {
              value = value.slice(1, -1)
            }
            return [parts[0], value]
          })
      )
      assert(headers.category.toLowerCase() === category, filePath)

      // Render body
      const html = MARKDOWN_CONVERTER.makeHtml(content)

      const id = path.basename(filename, '.md')
      const createdAt = new Date(ensure(headers.created_at, filePath))
      const description = headers.description ||
        (content.length <= 100) ? content.replace("\n", ' ') : `${content.replace("\n", ' ').slice(0, 97)}...`

      return {
        targetPath: path.join(BUILD_DIR, category, id, 'index.html'),
        url: `/${category}/${id}/`,
        title: ensure(headers.title, filePath),
        createdAt: createdAt,
        createdAtStr: createdAt.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }),
        updatedAt: new Date(ensure(headers.updated_at, filePath)),
        category: category,
        categoryCapitalized: capitalize(category),
        description: description,
        html,
      }
    })

  console.log(`Category ${category}: ${files.length} files`)
  return [category, files]
}))
const allFiles = Object.values(filesByCategory).flat()
function getFilesByDate(files) {
  const filesWithDate = files.map((file) => {
    const year = file.createdAt.getFullYear()
    const month = file.createdAt.getMonth() + 1
    const monthStr = file.createdAt.toLocaleString('en-us', { month: 'short' })
    return { ...file, year, month, monthStr }
  })
  const filesByDate =
    Object.entries(groupBy(filesWithDate, (file) => file.year))
      .sort((a, b) => b[0] - a[0])
      .map(([year, files]) => {
        const filesByMonth = Object.entries(groupBy(files, (file) => file.month))
          .sort((a, b) => b[0] - a[0])
          .map(([month, files]) => ({
            month,
            monthStr: files[0].monthStr,
            files: files.sort((a, b) => b.createdAt - a.createdAt),
          }))
        return { year, filesByMonth }
      })
  return filesByDate
}

// Read templates
const templates = Object.fromEntries(fs.readdirSync(TEMPLATES_DIR).map(filename => {
  const name = filename.replace(/\.html$/, '').replace('index', '')
  const content = fs.readFileSync(path.join(TEMPLATES_DIR, filename), { encoding: 'utf-8' })
  return [name, content]
}))
const _ARTICLE = ensure(templates._article)
const _BASE = ensure(templates._base)
const _POEM = ensure(templates._poem)

/**
 * Render template with given env mapper
 * @param {string} template
 * @param {object} env
 * @param {string | undefined} children
 * @returns {string}
 */
function render(template, env, children) {
  env = {
    currentYear: new Date().getFullYear(),
    ...env,
    children,
  }
  const lines = template.split("\n")

  const result = []
  for (let index = 0; index < lines.length; index++) {
    let line = lines[index]

    const loopMatch = line.trim().match(/^\{\{\s*loop\s+(\w*)\s*\}\}$/)
    if (loopMatch) {
      // Loop begins
      const key = loopMatch[1]
      const collection = ensure(env[key], `Env collection '${key}' is not provided`)

      // Find end
      const endIndex = lines.findIndex((line, i) => i > index && line.trim().match(new RegExp(`^{{\\s*end\\s+${key}\\s*}}$`)))
      assert(endIndex !== -1, `No matching loop_end for ${key}`)
      const loopTemplate = lines.slice(index + 1, endIndex).join("\n")
      assert(loopTemplate, `Loop template is empty for ${key}`)

      // Render loop
      for (const item of collection) {
        result.push(render(loopTemplate, {
          ...env,
          ...item,
        }))
      }

      // Skip to the end of loop
      index = endIndex
    } else {
      // Simply replacement
      [...line.matchAll(/\{\{\s*(\w*)\s*\}\}/g)].forEach(([placeholder, key]) => {
        const value = ensure(env[key], `Env '${key}' is not provided`)
        line = line.replace(placeholder, value)
      })
      result.push(line)
    }
  }

  return result.join("\n")
}


// Generate article HTML files
allFiles.forEach((file) => {
  console.log(`Rendering: ${file.url}`)
  const env = {
    title: file.title,
    metadata: file.createdAtStr,
    description: file.description,
  }
  const content =
    render(_BASE, env,
      render(file.category === 'poem' ? _POEM : _ARTICLE, env, file.html))
  writeFile(file.targetPath, content)
})


// Generate /memories/ page
{
  console.log(`Rendering: /memories/`)
  const env = {
    title: 'Memories',
    metadata: '三千竹水，不生不灭',
    description: '三千竹水，不生不灭',
    memories: getFilesByDate(allFiles),
  }
  const content = render(_BASE, env, render(templates._memories, env))
  writeFile(path.join(BUILD_DIR, 'memories', 'index.html'), content)
}


// Generate categories files
{
  console.log(`Rendering: /categories/`)
  const env = {
    title: 'Ranmocy\'s',
    metadata: '情，思，技',
    description: '情，思，技',
    groups: Object.entries(GROUPS).map(([groupId, categories]) => ({
      groupName: capitalize(groupId),
      categories: categories.map((id) => ({
        id,
        name: capitalize(id),
        tagline: CATEGORY_TAGLINES[id],
        size: filesByCategory[id].length,
      })),
    })),
  }
  const content = render(_BASE, env, render(templates._categories, env))
  writeFile(path.join(BUILD_DIR, 'categories', 'index.html'), content)
}
CATEGORIES.forEach((category) => {
  console.log(`Rendering: /${category}/`)
  const env = {
    title: capitalize(category),
    metadata: CATEGORY_TAGLINES[category],
    description: CATEGORY_TAGLINES[category],
    memories: getFilesByDate(filesByCategory[category]),
  }
  const content = render(_BASE, env, render(templates._memories, env))
  writeFile(path.join(BUILD_DIR, category, 'index.html'), content)
})


// Generate root files
Object.entries(templates).filter(([name]) => !name.startsWith('_') && path.extname(name) === '').forEach(([name, template]) => {
  console.log(`Rendering: /${name}`)
  const env = {
    title: TITLE,
    metadata: TAGLINE,
    description: TAGLINE,
  }
  const content = render(_BASE, env, template)
  writeFile(path.join(BUILD_DIR, name, 'index.html'), content)
})


// Generate atom.xml
{
  console.log(`Rendering: /atom.xml`)
  const env = {
    title: TITLE,
    tagline: TAGLINE,
    feedUpdatedAt: allFiles.map(file => file.updatedAt).sort()[0].toISOString(),
    files: allFiles.sort((a, b) => b.createdAt - a.createdAt).map(file => ({
      ...file,
      createdAt: file.createdAt.toISOString(),
      updatedAt: file.updatedAt.toISOString(),
    })),
  }
  const content = render(templates['atom.xml'], env)
  writeFile(path.join(BUILD_DIR, 'atom.xml'), content)
}


// Copy public files
fs.readdirSync(PUBLIC_DIR, { recursive: true })
  .filter((filename) => !fs.statSync(path.join(PUBLIC_DIR, filename)).isDirectory())
  .forEach((filename) => {
    console.log(`Copying /${filename}`)
    const srcPath = path.join(PUBLIC_DIR, filename)
    const targetPath = path.join(BUILD_DIR, filename)
    // No overriding
    assert(!fs.existsSync(targetPath), targetPath)
    fs.mkdirSync(path.dirname(targetPath), { recursive: true })
    fs.cpSync(srcPath, targetPath)
  })


/**
 * Assert condition exists
 * @param {any} cond
 * @param {string} msg
 * @returns cond
 */
function ensure(cond, msg) {
  assert(cond, msg)
  return cond
}

/**
 * Group by.
 * @param {Array[T]} arr
 * @param {(T) => string} keyFunc
 * @returns {object}
 */
function groupBy(arr, keyFunc) {
  return arr.reduce((res, elem) => {
    const key = keyFunc(elem)
    if (!(key in res)) {
      res[key] = []
    }
    res[key].push(elem)
    return res
  }, {})
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

function writeFile(targetPath, content) {
  fs.mkdirSync(path.dirname(targetPath), { recursive: true })
  fs.writeFileSync(targetPath, content)
}
