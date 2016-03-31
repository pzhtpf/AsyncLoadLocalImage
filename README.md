# AsyncLoadLocalImage

[![CI Status](http://img.shields.io/travis/pzhtpf/AsyncLoadLocalImage.svg?style=flat)](https://travis-ci.org/pzhtpf/AsyncLoadLocalImage)
[![Version](https://img.shields.io/cocoapods/v/AsyncLoadLocalImage.svg?style=flat)](http://cocoapods.org/pods/AsyncLoadLocalImage)
[![License](https://img.shields.io/cocoapods/l/AsyncLoadLocalImage.svg?style=flat)](http://cocoapods.org/pods/AsyncLoadLocalImage)
[![Platform](https://img.shields.io/cocoapods/p/AsyncLoadLocalImage.svg?style=flat)](http://cocoapods.org/pods/AsyncLoadLocalImage)

##简介(Introduction)
<p>如果你的iOS项目中需要加载项目中或者沙盒中的多张高清大图时，希望这个框架能助你一臂之力。</p>
<p>If your iOS project needs to be loaded  multi high quality images in the project or sandbox, hope this framework can help you.</p>
<p>类似于SDWebImage ，异步加载。两种缓存机制：内存和硬盘。</p>
<p>Similar to the SDWebImage, asynchronous loading. Two types of caching mechanism: memory and hard disk.</p>
<br/>
<br/>
<p><img src="http://img.blog.csdn.net/20160331154903426" alt="这里写图片描述" title=""></p>
<br/>
##<p><strong>两种用法(two usages)</strong></p>
<ol>
<li>UIImageView(category)</li>
</ol>
<pre class="prettyprint" name="code"><code class="hljs objectivec has-numbering"><span class="hljs-preprocessor">#import <span class="hljs-title">&lt;AsyncLoadLocalImage/TPF_ImageViewLoadLocalImage.h&gt;</span></span>

[cell<span class="hljs-variable">.imageView</span> loadLocalImageWithUrl:path callback:^(<span class="hljs-built_in">UIImage</span> *image, <span class="hljs-built_in">NSString</span> *url, <span class="hljs-built_in">BOOL</span> finished){

<span class="hljs-comment">// do something</span>
}]; </code><ul class="pre-numbering"></ul></pre>

<ol>
<li>异步加载图片(Asynchronous loading images)</li>
</ol>
<pre class="prettyprint" name="code"><code class="hljs objectivec has-numbering"><span class="hljs-preprocessor">#import <span class="hljs-title">&lt;AsyncLoadLocalImage/TPF_loadLocalImage.h&gt;</span></span>


[[TPF_LoadLocalImage sharedImageCache] loadLocalImageWithUrl:path callback:^(<span class="hljs-built_in">UIImage</span> *image, <span class="hljs-built_in">NSString</span> *url, <span class="hljs-built_in">BOOL</span> finished){

<span class="hljs-comment">// do something</span>

}];</code><ul class="pre-numbering"></ul></pre>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AsyncLoadLocalImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AsyncLoadLocalImage"
```

## Author

pzhtpf, 389744841@qq.com

## License

AsyncLoadLocalImage is available under the MIT license. See the LICENSE file for more info.
