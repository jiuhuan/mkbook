![MKBook](http://gtms02.alicdn.com/tps/i2/TB1aiz1HXXXXXbxXXXX2SziLXXX-266-69.png)

MKBook
---------
作者：九幻 <by11880@gmail.com>

### 安装

`> npm install mkbook`

### Markdown文档格式约束 

根目录必须有索引文件`index.md`，如下例：

```
### 目录
* [一级标题1](./main.md)
  * [google](http://www.google.com/doc/doc.md)
  * [二级标题](./a/a.md)
  * [二级标题](./a/a.md)
  * [二级标题](./a/a.md)
  * [二级标题](./a/a.md)
    * [三级标题](./a/a.md)
    * [三级标题](./a/a.md)
* 一级标题2
* [一级标题3](./a/a.md)
* 一级标题4
* 一级标题5
```

### honeycomb使用配置，config.default.yaml

```
'/ > mkbook':
  'title'     : '文档中心'              # 文档title
  'layout'    : './stages/doc.jade'    # 文档页面布局
  'defaults'  : './main.md'            # 默认打开的文档
  'dir'       : './doc'                # 文档源目录
  'mode'      : 'html'                 # 渲染模式
  'url_base'  : '/'                    # url的base路径
```

### connect 使用

```
var app = connect();
var options = {
  title: '文档中心',
  defaults: './main.md'
};
app.use(mkbook(options).middleware())
```

### 模板变量（基于jade）:

- `doc_title` 文档标题
- `css_markdown` markdown默认的github风格样本
- `doc_index` 文档目录
- `doc_content` 文档内容

###  运行实例

`> node ./example/app.js`
