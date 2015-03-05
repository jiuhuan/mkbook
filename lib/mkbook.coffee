###
 * mkbook - ./lib/mkbook
 * markdown文档生成htmlbook
 * 九幻<hanbing.hb@alibaba-inc.com>
 * Copyright(©) 2015 alibaba.com
###

jade = require 'jade'
events = require 'events'
path = require 'path'
fs = require 'fs'
marked = require 'marked'
globalUrl = require 'url'

root_path = path.join __dirname, '../../../'

class Mkbook extends events.EventEmitter
  constructor: (options) ->
    {title, layout, dir, mode, url_base, defaults} = options or {}

    title = 'Docments' unless title
    if layout
      layout = path.resolve root_path, layout
    else
      layout = path.join __dirname, '../public/layout.jade'

    if dir
      dir = path.resolve root_path, dir
    else
      dir = path.join __dirname, '../doc'

    mode = 'html' unless mode

    url_base = null unless url_base

    defaults = 'main.md' unless defaults
    
    @options = {title, layout, dir, mode, url_base, defaults}

    @marked = marked
    @marked.setOptions
      Renderer      : new marked.Renderer()
      gfm           : true
      tables        : true
      breaks        : false
      pedantic      : false
      sanitize      : true
      smartLists    : true
      smartypants   : false

  make: (file)->
    try
      html = @escape @marked file.toString()
    catch e
      html = e
      @emit 'error', e
    html

  parse: (filename)->
    { dir } = @options
    filename = path.join dir, filename
    # 权限检查，只能查看doc下的文档
    return null unless @_checkDirPermission filename
    file = @readFile path.join dir, 'index.md'
    doc_index = if file? then @make file else null
    file = @readFile filename
    doc_content = if file? then @make file else null
    if doc_index? and doc_content? then {doc_index, doc_content} else null

  escape: (str)->
    { url_base } = @options
    str.replace /(href|src)=\"([^"]+)\"/g, (str, attr, link)-> 
      # console.log arguments
      if -1 is link.indexOf '://' 
        new_link = link.replace '.md', '.html'
        new_link = path.join url_base, new_link
      else
        new_link = link
      str.replace link, new_link

  render: (data)->
    { layout, title, url_base } = @options
    data.doc_title = title
    data.css_markdown = path.join url_base, './markdown.css'
    fn = jade.compileFile layout, filename: layout
    fn data

  readFile: (filename)->
    exists = fs.existsSync filename
    return null unless exists
    fs.readFileSync filename

  _checkDirPermission: (filename)->
    { dir } = @options
    if 0 is filename.indexOf dir then true else false

  _reshtml: (res, data)->
    if data?
      res.writeHead 200, 'Content-Type': 'text/html'
      res.end @render data
    else
      res.writeHead 404, 'Content-Type': 'text/plain'
      res.end 'Not Found'

  _rescss: (res, data)->
    if data?
      res.writeHead 200, 'Content-Type': 'text/css'
      res.end data
    else
      res.writeHead 404, 'Content-Type': 'text/css'
      res.end null

  _resimage: (res, data)->
    if data?
      res.status = 200
      res.end data
    else
      res.status = 404
      res.end null

  _decodeURIComponent: (str)->
    try
      str = decodeURIComponent str
    catch e
    str

  middleware: ()->
    (req, res, next)=>
      {url, originalUrl} = req
      url = @_decodeURIComponent url
      url = globalUrl.parse(url).pathname
      originalUrl = @_decodeURIComponent originalUrl
      originalUrl = globalUrl.parse(originalUrl).pathname
      # 自动获取DOC根目录
      unless @options.url_base
        if '/' is url
          url_base = originalUrl
        else
          url_base = originalUrl.substring(originalUrl.length - url.length + 1, -1)
        @options.url_base = url_base or '/'
      # ...
      extname = path.extname url
      if '.html' is extname
        data = @parse url.replace '.html', '.md'
        @_reshtml res, data
      else if '.css' is extname
        data = @readFile path.join __dirname, '../', 'public', url
        @_rescss res, data
      else if -1 isnt ['.jpg', '.png', 'gif'].indexOf extname
        data = @readFile path.join @options.dir, url
        @_resimage res, data
      else if '/' is url
        data = @parse @options.defaults
        @_reshtml res, data
      else
        next()

module.exports = (arg)->
  new Mkbook arg
