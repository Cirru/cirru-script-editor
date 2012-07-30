
`Cirru` 是 [`code_blocks`](https://github.com/jiyinyiyong/code_blocks) 之后觉得编辑器设计得不好于是重构的,  
我有就着编辑器产生的数组设计语法比 Lisp 更简洁的语言的想法, 不过还早.  
目前依赖 Chrome 和 jQuery 的情况下可以运行, 可以单独尝试.  
不过 `contenteditable` 属性不是很完善, 即便我调试还是有没解决的小问题.  
我的例子托放在 gh-pages 上面, 可以用来测试是否能运行.  
http://jiyinyiyong.github.com/cirru-editor/page/p.html  
另外我把代码分离成文件了, 可以在其他的网页引用.  

    <header id="cirru"></header>
    <script src='http://code.jquery.com/jquery-1.7.1.js'></script>
    <script src='http://jiyinyiyong.github.com/cirru-editor/page/editor.js'></script>
    <link rel='stylesheet' href='http://jiyinyiyong.github.com/cirru-editor/page/s.css'>
    <script>
      cirru();
    </script>

简单的演示, 除了候选词提示, 其他有录制视频做过说明, 但样式表有不同:  
http://www.tudou.com/programs/view/1lUnTZvgsrk/?phd=99  
快捷键的说明:  

* `Tab` 结束当前字串开始下一个字串  
* `Enter` 产生嵌套  
* `up/down arrow` 将光标位置按字符前进后退  
* `pgup/pgdown` 遍历候选词  
* `ESC` 临时去掉候选词  
* `Delete` 删除字串  

另外受候选词菜单影响, `Tab` 使用候选词, `Enter` 则是选中. 方向键不影响.  

gh-pages 上的例子我加了一层计算器的 live-coding  
因为解释器不会写和 DOM 操作不熟悉的缘故较长时间不再更新  
其中的空格键阻断键盘事件不太有效, 有办法的话尝试更改一下  
一个测试的视频发在了土豆上, 大致可以看下  
http://www.tudou.com/programs/view/SWKnhfmduos/  
