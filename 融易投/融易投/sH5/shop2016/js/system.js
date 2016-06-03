$(function () {
    //模块--滑动导航
    (function () {
        var mySwiper = new Swiper('.tabs-nav', {
            freeMode: true,
            slidesPerView: 'auto',
        });
        swiperContainerOption.speed = 500;
        swiperContainerOption.onSlideChangeStart = function () {
            $(".tabs-nav .active").removeClass('active');
            $(".tabs-nav .swiper-slide").eq(tabsSwiper.activeIndex).addClass('active');
            mySwiper.slideTo(tabsSwiper.activeIndex);
            tabsHeight();
        }
        var tabsSwiper = new Swiper('#tabs-container', swiperContainerOption);
        $(".tabs-nav .swiper-slide").on('touchstart mousedown', function (e) {
            e.preventDefault()
            $(".tabs .active").removeClass('active')
            $(this).addClass('active')
            $(".tabs-nav .swiper-slide").eq(tabsSwiper.activeIndex).addClass('active')
            tabsSwiper.slideTo($(this).index());
            mySwiper.slideTo($(this).index());

        })
        $(".tabs-nav .swiper-slide").click(function (e) {
            e.preventDefault();
        });
        //计算每个模块的高度
        tabsHeight();
        function tabsHeight() {
            var $container = $('#tabs-container'),
                h = $('#tabs-container').find('.swiper-slide-active').height();
            // console.log(h)
            $('.com-nav').css({'height': h + 49 + 'px'});
        }

        //固定nav
        //noinspection JSUnresolvedFunction
        $(window).scroll(function () {
            //noinspection JSValidateTypes
            var d = $(document).scrollTop(),
                comNav = $('.com-nav'),
                comNavTop = comNav.position().top + 35;
            if (d >= comNavTop) {
                comNav.find('.tabs-nav').css({'width': '100%', 'position': 'fixed', 'top': 0, 'left': 0})
            } else {
                comNav.find('.tabs-nav').css({'position': '', 'top': '', 'left': ''})
            }
        })
    })();
    //轮播图
    (function () {
        var mySwiper = new Swiper('.swiper-container', {
            autoplay: 5000,//可选选项，自动滑动
        })
    })();
    //详情页
    (function () {
        var navPic = $('.nav-pic2');
        navPic.each(function () {
            var liMore = $(this).find('li:gt(9)');
            liMore.hide();
            $(this).find('.more').click(function () {
                $(this).hide();
                liMore.show();
                return false;
            });
            $(this).find('.close').click(function () {
                $(this).hide();
                $(this).siblings('.more').show();
                liMore.hide();
                return false;
            });
        })


    })();
    //注册登录
    (function () {
        //验证码
        var countdown = 60;

        function settime(obj, color) {
            if (countdown == 0) {
                obj.removeAttribute("disabled");
                obj.value = "发送验证码";
                countdown = 60;
                obj.style.color = '';
                return;
            } else {
                obj.setAttribute("disabled", true);
                obj.value = countdown + " S";
                countdown--;
                obj.style.color = color
            }
            setTimeout(function () {
                settime(obj)
            }, 1000);
        }

        $('#btn-verify').click(function () {
            settime(this, '#d9d9d9')
        });

        //选择性别
        $('.base-user .check-sex a').click(function () {
            $(this).addClass('active').siblings('a').removeClass('active');
            return false;
        })


    })();
    //拍卖详情
    (function () {
        var ParentDiv = $("#bottomButton");
        var btnPay = $('#btn_pay');
        var click = function () {
            var btnPayPannel = $('#btn_pay_pannel');
            btnPayPannel.addClass('jshow');
            btnPayPannel.find('.close').click(function () {
                btnPayPannel.removeClass('jshow');
            })
            return false;
        };
        ParentDiv.on("click", "#btn_pay", click);
        var click2 = function () {
            $(this).toggleClass('active');
        }
        ParentDiv.on("click", "#radio", click2);

        if ($('div').hasClass('pm_btm_bar')) {
            //$('body').css('margin-bottom','60px')
        }
    })();
})