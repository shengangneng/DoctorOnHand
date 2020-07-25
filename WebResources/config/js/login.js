$(function () {
    $(".content .con_right .right").click(function (e) {
        $(this).css({ "color": "#333333", "border-bottom": "2px solid #2e558e" });
        $(".content .con_right .left").css({ "color": "#999999", "border-bottom": "2px solid #dedede" });
        $(".content .con_right ul .con_r_right").css("display", "block");
        $(".content .con_right ul .con_r_left").css("display", "none");
    });

  

    $('#btn_Login').click(function () {
        console.log($('#frontid').val())
        console.log($('#fportid').val())
        console.log($('#backid').val())
        console.log($('#bportid').val())
        if ($.trim($('#frontid').val()) == '') {
            alert('请输入您的前端IP');
            return false;
        } else if ($.trim($('#fportid').val()) == '') {
            alert('请输入前端端口号');
            return false;
        } else if ($.trim($('#backid').val()) == '') {
            alert('请输入后端IP');
            return false;
        } else if ($.trim($('#bportid').val()) == '') {
            alert('请输入后端端口号');
            return false;
        } else {
            return true;
        }
    });
})