
// 分析
//    如何对前端错误分类？
// 有些错误，一个都不允许出现 出现就报警
//    都是哪些？要产出个列表
//    按处理时间分错误等级，参考需求优先级 P0,P1,P2,P3
// 有些错误，修复了又出现
//    都修复了哪些
// 有些错误，是第三方的错误，可以忽略
//    参考 sentry 入站过滤器，arms 错误过滤设置等可制定相关规则
// 错误类型，分析问题产生原因，快速解决问题

// - a-issue-tracking 问题跟踪

// https://blog.51cto.com/liyanwen/1982361
// 软件缺陷有四种级别，分别为：致命的(Fatal)，严重的(Critical)，一般的(Major)，微小的(Minor)
// BUG的严重级别分类 BUG状态标准
// https://www.cnblogs.com/wei9593/p/10218186.html
// BUG状态标准
// 待处理（new）：测试人员或用户发现新问题后提交的状态
// 已确认（open）：经测试人员及研发人员讨论后确认是BUG，提交的状态，由测试人员来设置。
// 已处理（fixed）：经研发人员确认是BUG后修复的状态，修改还没有验证，由开发人员来设置。
// 已修改（closed）：测试人员认为问题已经修改，通过验证，由测试人员设置。
// 仍存在（reopened）：测试人员认为BUG未修复成功，问题仍然存在，由测试人员设置。
// 不是问题（reject）：研发人员确认不是BUG，或者建议与意见决定不采纳。
// 暂不处理（hold）：当前版本不做修改，后续版本再考虑，由研发人员或测试人员设置。

// Bug等级划分标准
// https://juejin.cn/post/6844903687588937742
// http://www.51testing.com/html/14/175414-143036.html
// https://www.alltesting.cn/news/169.html

// Bug的管理与跟踪
// http://www.51testing.com/html/04/n-7793304.html

// 链接：https://www.nowcoder.com/questionTerminal/b6689afc2de2434e83e11e8bb03fc926
// 软件缺陷的等级可以用严重性和优先级来描述；
// 严重性：衡量缺陷对客户满意度影响的满意程度，分为
// 1.致命错误：系统任何一个主要功能完全丧失，用户数据受到破坏，系统崩溃、悬挂、死机或者危及人身安全。
// 2.严重错误：系统的主要功能部分丧失，数据不能保存，系统的次要功能完全丧失，系统所提供的功能或服务受到明显的影响 。
// 3.一般错误：系统的次要功能没有完全实现，但不影响用户的正常使用。例如：提示信息不太明确或用户界面差，操作时间长等一些问题。
// 4.较小：是操作不方便或者遇到麻烦，但它不影响功能的操作和执行，如个别不影响产品理解的错别字、文字排列不整齐等一些小问题。

// 软件缺陷的等级可以用严重性和优先级来描述；
// 严重性：衡量缺陷对客户满意度影响的满意程度，分为
// 1,致命错误，可能导致本模块以及其他相关的模块异常，死机等问题；
// 2.严重错误，问题局限在本模块，导致模块功能失常或异常退出；
// 3.一般错误，模块功能部分失效；
// 4.建议模块，有问题提出人对测试模块的改进建议；
// 优先级：缺陷被修复的紧急程度；
// 1.立即解决（P1级）：缺陷导致系统功能几乎不能使用或者测试不能继续，需立即修复；
// 2.高优先级（P2级）：缺陷严重，影响测试，需优先考虑；
// 3.正常排队（P3级）：缺陷需要正常排队等待修复；
// 4.低优先级（P4级）：缺陷可以在有时间的时候被纠正；

// 前端错误分类
//  1. 即时运行错误：代码错误
//  2. 资源加载错误：包括 js、css、图片等加载失败

[
  'null is not an object', // null is not an object (evaluating 'n.statusText')
  'undefined is not an object', // undefined is not an object (evaluating 't.code')
  'undefined is not a function', // undefined is not a function (near '...age=f||c}})).finally((function(){Object(...')
  'Cannot read property ',  // Cannot read property 'statusText' of null
                            // Cannot read property '2' of null
  "Cannot read property 'charAt' of undefined",
  // "Can't find variable: WeixinJSBridge",
  "Script error.",
  "", // ChunkLoadError: Loading chunk 6 failed.
];


// 不允许出现的错误
null is not an object*
undefined is not an object*
undefined is not a function*
*is not a function
Cannot read property*
Unexpected token*
// 待排查
ChunkLoadError*


// sentry 入站过滤器
// 过滤器
// 1. 过滤已知由浏览器扩展引起的错误
// 2. 过滤掉来自本地主机的事件
// 3. 过滤掉旧版浏览器中的已知错误
//    各种低版本的浏览器
// 4. 过滤掉已知的网络爬虫
// 自定义过滤器
// 1. IP 地址
// 2. 版本（允许glob 模式匹配）
// 3. 错误信息（按错误消息过滤事件。用换行符分隔多个条目。允许glob 模式匹配。）

/*

*Non-Error*
*ChunkLoadError*
ResizeObserver loop limit exceeded
*UnknownError*
expected expression, got '<'
Cannot read properties of null (reading 'startColumn')
Cannot read properties of null (reading 'getComputedStyle')
*Request failed with status code 403*
*(reading 'getComputedStyle')*
*(reading 'startColumn')*

*/

// 如何对前端错误分类
// 错误监控平台：https://www.yuque.com/zaotalk/posts/c5-5

