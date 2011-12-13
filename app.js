var sideDetail = false;


$(document).ready(function(){
url = "http://www.itpirl.com/floorsquare";
$container = $('#allStudentsBoard');


var setListElements = function(){
        $('#allStudentsBoard').isotope({
            itemSelector : '.studentBox',
            layoutMode : 'fitRows',
            resizable: true,
            resizesContainer: true,
        });

      $('#allStudentsBoard').isotope({
      getSortData : {
        skill : function ( $elem ) {
            // console.log($elem.find('.skill').text());
          return $elem.find('.skill').text();
        },
        name : function ( $elem ) {
            // console.log($elem.find('.nameDisplay').text());
          return $elem.find('.nameDisplay').text();
        }
      }
    });    

};  // /setListElements


var setupSwipeInputOnEnter = function(context){
$("#swipeInput").keypress(function(e){
  if(e.which == 13){
    e.preventDefault();
    var q=$("#swipeInput").val(); 
    context.redirect("#/dashboard" +q) //redirect to the main dashboard once swiped
   } // /if 13-enter
}); // /keypress
};


var app = Sammy('#contentMain', function() {
  // include a plugin
  this.use('Mustache');


  // define a 'route' for the home page, which is the all students board
  this.get('#/', function(context) {
    setListElements(); //isotope
    setupSwipeInputOnEnter(context);
    $("#allStudentsBoard").show();

    // load some data
    this.send($.getJSON, url+"/swipes", { app_key: "82ac7bdb2e8ef44b5a2124f43ee05479" , device_id: '1', extra: {checkin: true}})
    .then(function(json){
        // console.log(json);
        //make skills an array of strings, instead of just a string
        processed_swipes= [];
        for(i in json)
        {
          swipe= json[i]
          swipe.user.extra.app_id_1.skills= swipe.user.extra.app_id_1.skills.split(",");

          if (swipe.extra.app_id_1.available=="true")
          {
            swipe.avail= "available";
          }
          else
          {
            swipe.avail = "unavail";
          }
          // swipe.isunavail=  ? 
          processed_swipes.push(swipe);
        }

        // console.log(processed_swipes);

        this.renderEach('student.mustache', processed_swipes)//.appendTo("#allStudentsBoard")
        .then(function(items){
            // console.log(items);
            items = $(items);
            // $("#allStudentsBoard").isotope( 'appended', items );
            $('#allStudentsBoard').isotope('insert', items );
            fadeUnavail();

        });
    })

  }); // end get #/

 // 
  this.get('#/checkin/:nnumber', function(context) {
   
   var nnumber=this.params['nnumber'];
   var swipeid = null;
   $("#allStudentsBoard").empty().isotope('destroy').hide();


    this.send($.ajax, url+"/swipes/new", {
        data: { user_nnumber: nnumber, app_id: '1', device_id: '1', app_key: "82ac7bdb2e8ef44b5a2124f43ee05479",  extra: {checkin: true, }},
        type: 'POST',
        crossDomain: true,
        success: function(data){
            console.log('data',data);
            // extra.app_id_1.skills= extra.app_id_1.skills.split(",");
            swipeid=data.swipeid;
            context.render('swipe.mustache', data).appendTo('#contentMain')
            .then(function(){
              // console.log('hii');
              $('#skillfield').tagsInput({
                width: '780',
                height:' 40px',
              });


              $(".submitAsAvailable").click(function() {
                 context.send($.ajax, url+"/swipes/"+swipeid, {
                        data: { user_nnumber: nnumber, app_id: '1', device_id: '1', app_key: "82ac7bdb2e8ef44b5a2124f43ee05479",  extra: {checkin: true, available: true }},
                        type: 'POST',
                        crossDomain: true,
                        success: function(data){
                            console.log('sucessss');
                            postSkills(nnumber);
                            $(".formpage").hide();
                            context.redirect("#/");
                          }  //end success
                  });  // /send ajax
              }); // /click



              $(".submitAsUnavailable").click(function(){
                 context.send($.ajax, url+"/swipes/"+swipeid, {
                        data: { user_nnumber: nnumber, app_id: '1', device_id: '1', app_key: "82ac7bdb2e8ef44b5a2124f43ee05479",  extra: {checkin: true, available: false }},
                        type: 'POST',
                        crossDomain: true,
                        success: function(data){
                            console.log('sucessss');
                            postSkills(nnumber);
                            $(".formpage").hide();

                            context.redirect("#/");

                          }  //end success
                  });  // /send ajax
              }); // /click



            });  // end then of initial ajax call



            // console.log('this probably happens before hi');
            //and then render it here because I can't figure out sammy all the way.
        } 
    });





  }); //end get #/checkin


});  //end sammy app

// start the application
app.run('#/');




var fadeUnavail = function(){ 
    var studentImages = $(".studentBox img");
    $(studentImages).each(function(index) {
        if ($(this).hasClass('unavail')) {
          // console.log($(this).parent('li'));
            $(this).parent('li').css({'background-color' : 'rgba(20,20,20,0.8)', 'opacity' : '0.5 !important', 'color' : '#aaa'});
        }
     });
};

fadeUnavail();


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


 var studentFilter = function(q, object) {
   // make option object dynamically, i.e. { filter: '.my-filter-class' }
    var options = {},
        key = "filter"; //$optionSet.attr('data-option-key'),
        value = '.'+q;
        // console.log("q = "+q);
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
 });   

var keyHistory = '';
var gettingNnumber=false;
var nn='';
$(document).keypress(function(e) {
    key=String.fromCharCode(e.which);

    if (gettingNnumber && key=="=")
    {
      console.log('nnumber is', nn);
      gettingNnumber=false;
      keyHistory= '';
      //send it in
      app.setLocation("#/checkin/"+nn);

      return false;
      // console.log(app.get("#/checkin/"+nn));
      // $("#swipeInput").val(nn).submit();

    }

    if (gettingNnumber)
    {
      nn+=key;
    }


    if (key == "8" && keyHistory[keyHistory.length-1]==";")
    {
      gettingNnumber=true;
      keyHistory= '';
    }
    else
    {
      keyHistory += key;
    }

    console.log(keyHistory);
});

// ;817565215=2227?



var postSkills = function(nnumber){
  var memberskills=$("#skillfield").val();

  $.ajax({  url: url+"/members/"+nnumber,
            data: { user_nnumber: nnumber, app_id: '1', device_id: '1', app_key: "82ac7bdb2e8ef44b5a2124f43ee05479",  extra: {skills: memberskills}},
            type: 'GET',
            crossDomain: true,
            success: function(data){
                console.log('sucessss');
              }  //end success
        });
};


 
}); //end docready