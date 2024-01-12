#!/usr/bin/env -S node
// node = v18.18.2
// Run: .scripts/build.mjs
// Dev: ls -1 .*/**/* | grep -v '.build' | grep -v '.git' | entr -s 'node .scripts/build.mjs'
// Serve: npx serve .build

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
      const [headerStr, content] = contentParts

      // Extract headers
      const headerRendered = render(headerStr, { currentDate: new Date().toISOString() })
      const headers = Object.fromEntries(
        headerRendered.split("\n").slice(1)
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
      const updatedAt = new Date(ensure(headers.updated_at, filePath))
      const updatedAtStr = updatedAt.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' })
      const tagline = headers.tagline || updatedAtStr
      const description = headers.description || content.replace(/\s+/g, ' ').trim().slice(0, 97) + '...'

      return {
        url: `/${category}/${id}/`,
        title: ensure(headers.title, filePath),
        tagline,
        createdAtISO: createdAt.toISOString(),
        updatedAt,
        updatedAtISO: updatedAt.toISOString(),
        updatedAtStr,
        year: updatedAt.getFullYear(),
        month: updatedAt.getMonth() + 1,
        monthStr: updatedAt.toLocaleString('en-us', { month: 'short' }),
        category,
        categoryCapitalized: capitalize(category),
        description,
        html,
      }
    })

  console.log(`Category ${category}: ${files.length} files`)
  return [category, files]
}))
const allFiles = Object.values(filesByCategory).flat().sort((a, b) => b.updatedAt - a.updatedAt)

function getFilesByDate(files) {
  return Object.entries(groupBy(files, (file) => file.year))
    .sort((a, b) => b[0] - a[0])
    .map(([year, files]) => {
      const filesByMonth = Object.entries(groupBy(files, (file) => file.month))
        .sort((a, b) => b[0] - a[0])
        .map(([month, files]) => ({
          month,
          monthStr: files[0].monthStr,
          files: files.sort((a, b) => b.updatedAt - a.updatedAt),
        }))
      return { year, filesByMonth }
    })
}

// Read templates
const templates = Object.fromEntries(fs.readdirSync(TEMPLATES_DIR).map(filename => {
  const name = filename.replace(/\.html$/, '').replace('index', '')
  const content = fs.readFileSync(path.join(TEMPLATES_DIR, filename), { encoding: 'utf-8' })
  return [name, content]
}))
const _BASE = ensure(templates._base)

// Render files
const renderingFiles = [
  ...allFiles.map(file => ({
    ...file,
    templates: [file.category === 'poem' ? templates._poem : templates._article, _BASE],
  })),
  {
    url: '/memories/',
    templates: [templates._memories, _BASE],
    title: 'Memories',
    tagline: '三千竹水，不生不灭',
    description: '三千竹水，不生不灭',
    memories: getFilesByDate(allFiles),
  },
  {
    url: '/categories/',
    templates: [templates._categories, _BASE],
    title: 'Ranmocy\'s',
    tagline: '情，思，技',
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
  },
  ...(CATEGORIES.map((category) => ({
    url: `/${category}/`,
    templates: [templates._memories, _BASE],
    title: capitalize(category),
    tagline: CATEGORY_TAGLINES[category],
    description: CATEGORY_TAGLINES[category],
    memories: getFilesByDate(filesByCategory[category]),
  }))),
  // Root files
  ...(Object.entries(templates).filter(([name]) => !name.startsWith('_')).map(([name, template]) => {
    const isFile = name.endsWith('.xml')
    return ({
      url: isFile ? `/${name}` : `/${name}/`,
      templates: isFile ? [templates['atom.xml']] : [template, _BASE],
      title: TITLE,
      tagline: TAGLINE,
      description: TAGLINE,
      feedUpdatedAt: allFiles.map(file => file.updatedAt).sort()[0].toISOString(),
      allFiles: allFiles,
    });
  })),
]
renderingFiles.forEach((file) => {
  console.log(`Rendering: ${file.url}`)
  assert(file.url[0] === '/')
  const url = file.url.slice(1)
  const filepath = path.join(BUILD_DIR, url, url.endsWith('/') ? 'index.html' : '')
  const content = file.templates.reduce((rendered, template) => render(template, file, rendered), file.html)
  writeFile(filepath, content)
})


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


// Utils

function ensure(cond, msg) {
  assert(cond, msg)
  return cond
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1)
}

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

function writeFile(targetPath, content) {
  fs.mkdirSync(path.dirname(targetPath), { recursive: true })
  fs.writeFileSync(targetPath, content)
}

/**
 * Render template with given env mapper
 * @param {string} template
 * @param {object} env
 * @param {string | undefined} children
 * @returns {string}
 */
function render(template, env, children) {
  assert(template, 'Template is empty')
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
