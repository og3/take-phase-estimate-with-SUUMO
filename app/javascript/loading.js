$(document).on('turbolinks:load', function() {
  $('.form').submit(function() {
    var message = $('#message');
    message.text('物件情報を取得中です。しばらくお待ちください。');
  });
});
