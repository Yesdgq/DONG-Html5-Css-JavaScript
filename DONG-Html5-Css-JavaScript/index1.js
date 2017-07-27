
function hello(string){
    alert("你好"+string);
}


//var checkRegisterForm = function () {
//    var usr = document.getElementById('username'),
//    pwd = document.getElementById('password'),
//    pwd2= document.getElementById('password-2'),
//    err = document.getElementById('test-error'),
//    reg = /^\w{3,10}$/,
//    reg2 = /^.{6,20}$/,
//    testReg = reg.test(usr.value),
//    testReg2 = reg2.test(pwd.value);
//    if (!testReg) {
//        err.innerHTML = "不是跟你说了用户名要3-10位数字或字母吗？瞎是不是？";
//        return false;
//    }
//    if (!testReg2) {
//        err.innerHTML = "密码要6-20位之间啊，是装傻还是真傻？";
//        return false;
//    }
//    if (pwd.value !== pwd2.value) {
//        err.innerHTML = "再让你输一次都能输错，你的手是鸡爪子吗？";
//        return false;
//    }
//    return true;
//}


var checkRegisterForm = function () {
    var userName = document.getElementById('username');
    var passWord= document.getElementById('password');
    var passWordRepeat = document.getElementById('password-2');
    if(passWord.value !== passWordRepeat.value) {
        alert('两次的口令必须一致!');
        return false;
    }
    if(passWord.value.length < 6 || passWord.value.length > 20) {
        alert('口令长度必须在6到20位之间');
        return false;
    }
    var re = /^\w{3,10}$/;
    if(!re.test(userName.value)) {
        alert('用户名必须是3-10位英文字母或数字');
        return false;
    }
    return true;
}


// 演示了如何通过HTML5的File API读取文件内容。以DataURL的形式读取到的文件是一个字符串，类似于data:image/jpeg;base64,/9j/4AAQSk...(base64编码)...，常用于设置图像。如果需要服务器端处理，把字符串base64,后面的字符发送给服务器并用Base64解码就可以得到原始文件的二进制内容

var

fileInput = document.getElementById('test-image-file'),
info = document.getElementById('test-file-info'),
preview = document.getElementById('test-image-preview');
// 监听change事件:
fileInput.addEventListener('change', function () {
                           // 清除背景图片:
                           preview.style.backgroundImage = '';
                           // 检查文件是否选择:
                           if (!fileInput.value) {
                           info.innerHTML = '没有选择文件';
                           return;
                           }
                           // 获取File引用:
                           var file = fileInput.files[0];
                           // 获取File信息:
                           info.innerHTML = '文件: ' + file.name + '<br>' +
                           '大小: ' + file.size + '<br>' +
                           '修改: ' + file.lastModifiedDate;
                           if (file.type !== 'image/jpeg' && file.type !== 'image/png' && file.type !== 'image/gif') {
                           alert('不是有效的图片文件!');
                           return;
                           }
                           // 读取文件:
                           var reader = new FileReader();
                           reader.onload = function(e) {
                           var
                           data = e.target.result; // 'data:image/jpeg;base64,/9j/4AAQSk...(base64编码)...'
                           preview.style.backgroundImage = 'url(' + data + ')';
                           };
                           // 以DataURL的形式读取文件:
                           reader.readAsDataURL(file);
                           });

// 上面的代码还演示了JavaScript的一个重要的特性就是单线程执行模式。在JavaScript中，浏览器的JavaScript执行引擎在执行JavaScript代码时，总是以单线程模式执行，也就是说，任何时候，JavaScript代码都不可能同时有多于1个线程在执行。










