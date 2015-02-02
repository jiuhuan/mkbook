![MKBook](http://gtms02.alicdn.com/tps/i2/TB1aiz1HXXXXXbxXXXX2SziLXXX-266-69.png)

MKBook
---------
九幻<hanbing.hb@alibaba-inc.com>

### honeycomb使用配置，config.default.yaml
```
'/ > @ali/mkbook':
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

### 模板变量（基于jade）：

- `doc_title` 文档标题
- `css_markdown` markdown默认的github风格样本
- `doc_index` 文档目录
- `doc_content` 文档内容
