$(document).ready(function () {

    // #####################################
    // Tabs #20/03/2013 update @Hidalgo
    // #####################################

    $(".bp-tabs ul li a").on("click", function () {
        id_tab = $(this).closest(".bp-tabs").attr("id");
        $("#" + id_tab + " li").removeClass("active");
        $(this).closest("li").addClass("active");
        $("#" + id_tab + " .bp-tab-content").hide();
        $("#" + id_tab + " .bp-tab-content").removeClass("active");
        var activeTab = $(this).attr("href");
        $(activeTab).addClass("active");
        $(activeTab).fadeIn(); /* efecto aparecer */
        // $(activeTab).show();
    });

    // Initialize tabs
    bp_tabs_refresh();

});

function bp_tabs_refresh(){
    $(".bp-tab-content").hide();
    $(".bp-tabs ul li.active a").each(function (){
        id_div_active = $(this).attr("href");
        $(id_div_active).show();
    });
}

