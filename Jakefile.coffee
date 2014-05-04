child_process = require 'child_process'
JASMINE_PATH = './node_modules/jasmine-node/lib/jasmine-node/cli.js'
DIST_PATH = './jasmine-beforeSuite.js'

run_task = (cmd, cmpl_fn=complete) ->
  child_process.exec cmd, (error, stdout, stderr) ->
    process.stdout.write(stdout) if stdout.trim().length?
    process.stdout.write(stderr) if stderr.trim().length?
    cmpl_fn() if cmpl_fn?

desc 'Runs the entire test suite: ./spec/'
task 'spec', { async: true }, ->
  debug = if process.env.DEBUG? then '--debug-brk' else ''
  spec_file = process.env.SPEC || './spec'
  run_task "node #{debug} #{JASMINE_PATH} --coffee --verbose #{spec_file}", complete

desc 'Compiles ./src into jasmine-beforeSuite.js'
task 'build', ->
  fs = require('fs')
  cs = require('coffee-script')
  js = cs.compile(fs.readFileSync('./src/before_suite.coffee').toString())
  fs.writeFileSync(DIST_PATH, js)
  console.log("Compiled successfully. Saved in jasmine-beforeSuite.js")
