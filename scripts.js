   var $container = $('#allStudentsBoard');
    var testSkills = "ruby, javascript, geolocation, gamification, databases";
    var testSkillsJSON = $.toJSON( testSkills );
    // console.log("testSkills = "+testSkills);
    // console.log("testSkillsJSON = "+testSkillsJSON);
    var interval1=0;
    var stateObj = { foo: "edit" };
    var stateObj2 = { foo: "main" };
    var setListElements = function(){
            $('#allStudentsBoard').isotope({
                itemSelector : '.studentBox',
                layoutMode : 'fitRows',
                resizable: true,
                resizesContainer: true,
            });
    }
    setListElements();
     
    
    $('.updater').click(function(){
        $('.checkinpage').animate({opacity: "0"},200,'swing',function() {
            $('.checkinpage').hide();
            $('.formpage').show();
            $('.formpage').animate({opacity: "1"},250,'swing',function() {});
            history.pushState(stateObj, "page 2", "edit.html");
         });
    });
    
    $('.gotoMain').click(function(){
        $('.formpage').animate({opacity: "0"},200,'swing',function() {
            $('.formpage').hide();
            $('.mainpage').show();
            $('#searchBar').show();
            $('#seeAll').show();
            $('.mainpage').animate({opacity: "1"},250,'swing',function() {});
             $('#searchBar').animate({opacity: "1"},250,'swing',function() {});
            $('#seeAll').animate({opacity: "1"},250,'swing',function() {});
            history.pushState(stateObj2, "page 3", "main.html");
             setListElements();
         });
    });
        
var fadeUnavail = function(){ 
    var studentImages = $(".studentBox img");
    $(studentImages).each(function(index) {
        if ($(this).hasClass('unavail')) {
            $(this).parent('li').css({'background-color' : 'rgba(20,20,20,0.8)', 'opacity' : '0.5', 'color' : '#aaa'});
        }
     });
}
    fadeUnavail();
    
    $('.mainpage').hide();
    
    $("#searcher").live('focus', function() {
        if ($(this).val()=="search"){
            $(this).val("");
        }
        $(this).css({'background-color' : '#fff'});
        return false;
    });
    $("#searcher").live('blur', function() {
        $(this).css({'background-color' : 'rgb(245,245,187)'});
        return false;
    });  
      
    $('#content').isotope({
      getSortData : {
        skill : function ( $elem ) {
            console.log($elem.find('.skill').text());
          return $elem.find('.skill').text();
        },
        name : function ( $elem ) {
            console.log($elem.find('.nameDisplay').text());
          return $elem.find('.nameDisplay').text();
        }
      }
    })
    



/* ///////////////// CHECKIN SCRIPTS /////////////////*/

    var url = "http://www.itpirl.com/floorsquare";
    $('#skillshow').tagsInput({
        width: 'auto',
        height:' 40px',
        interactive: false,
    });
    $('a').each(function(index) {
       if($(this).text() == "x"){
           $(this).hide();
       }
    });

    
        $(".avail").click(function(){ 
            $.ajax({
                url: url+"/swipes/new",
                data: { user_nnumber: "19351591", app_id: '1', device_id: '1', app_key: "82ac7bdb2e8ef44b5a2124f43ee05479",  extra: {checkin: true, skills:testSkillsJSON}},
                type: 'POST',
                crossDomain: true,
                success: function(data){
                    console.log(data);
                   parseReturn(data);
                } 
            });
            console.log("posted");
        });
        
        $(".getStuff").click(function(){ 
            console.log('getting json');
            $.getJSON(url+"/swipes", { app_key: "82ac7bdb2e8ef44b5a2124f43ee05479" , device_id: '1', extra: {checkin: true}},
            function(data){
                console.log(data);
            });
            return false;
        }); 
     
/*   $('#checkin img').html('<img id="checkinPic" src="http://itp.nyu.edu/image.php?width=260&height=260&cropratio=1:1&image=/people_pics/itppics/jsd340.jpg" alt="jsd340" width="100" height="100"/>'); */
/*   $('#checkin img').attr({'src' : 'http://itp.nyu.edu/image.php?width=100&height=100&cropratio=1:1&image=/people_pics/itppics/jsd340.jpg'}); */
     
     var parseReturn = function(object) {
       var firstname = object.first,
       lastname = object.last;
       netid = object.netid;
       $('#checkin img').attr({'src' : "http://itp.nyu.edu/image.php?width=100&height=100&cropratio=1:1&image=/people_pics/itppics/"+netid+".jpg"});
       $('.greeting .formImg').attr({'src' : "http://itp.nyu.edu/image.php?width=100&height=100&cropratio=1:1&image=/people_pics/itppics/"+netid+".jpg"});
       $('.greeting h1').html("Hey " + firstname +" "+lastname+"! Thanks for checking in.");
       $('.greeting .namer').html("<span>Your Name</span><br/>"+ firstname +" "+lastname+"</p>");
       $('.greeting .netid').html("<span>Your NetId</span><br/>"+netid+"</p>");
       var $newItems = $('<li class="studentBox '+firstname+' '+lastname+'"><h4 class="nameDisplay">'+firstname+'<br/>'+lastname+'</h4><img src="http://itp.nyu.edu/image.php?width=260&height=260&cropratio=1:1&image=/people_pics/itppics/'+netid+'.jpg" alt="'+netid+'"width="100" height="100"/><p class="skill">I\'m the new guy</p></li>');
        $('#allStudentsBoard').append( $newItems ).isotope( 'addItems', $newItems );
       //setListElements();
     }
     
     var studentFilter = function(q, object) {
       // make option object dynamically, i.e. { filter: '.my-filter-class' }
        var options = {},
            key = "filter"; //$optionSet.attr('data-option-key'),
            value = '.'+q;
            console.log("q = "+q);
        // parse 'false' as false boolean
        value = value === 'false' ? false : value;
        options[ key ] = value;
        if ( key === 'layoutMode' && typeof changeLayoutMode === 'function' ) {
          // changes in layout modes need extra logic
          changeLayoutMode( $this, options )
        } else {
          // otherwise, apply new options
          $container.isotope( options );
        }
        intervalD1=setTimeout(fadeUnavail, 300);
     }

       $("#searcher").keypress(function(e){
          if(e.which == 13){
            e.preventDefault();
            q = $('#searcher').val();
            var $this = $(this);
            studentFilter(q, $this);
            return false;
        }
     });  
     
     $("#seeAll").click(function(e){
            q = "studentBox";
            var $this = $(this);
            studentFilter(q, $this);
            return false;
     })   
