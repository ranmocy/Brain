---
title: Spark Driver Less
created_at: 2015-04-22T22:53:52-0700
updated_at: 2015-06-27T13:24:04-0700
category: Piece
---

SparkDriverless is a totally decentralized system inspired by Spark,
but with a totally different approach for distributed computation.
It removes the Driver node from Spark to achieve single-point-failure-free.
Every worker in the cluster is exactly the same.
Even the client has similar mechanism with workers.
Nodes communicate with each other by broadcasting messages.
This allows any node, even the client, fails at any time,
without break the computation process.
And also it has a much simpler model compared to original Spark.

Fork me at [Github](https://github.com/ranmocy/SparkDriverLess).
Details at [Report](https://github.com/ranmocy/SparkDriverLess/blob/master/report.pdf)
