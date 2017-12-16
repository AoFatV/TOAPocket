
alert = function (msg) {
    $("#MessageBox .modal-body>p").html(msg);
    $('#MessageBox').modal('show');
};

confirmBox = function (msg, callback) {
    var fn = function () {
        $('#ConfirmBox').off('click', '.btn-ok', fn);
        callback();

    }
    $('#ConfirmBox').on('click', '.btn-ok', fn);
    $("#ConfirmBox .modal-body>p").html(msg);
    $('#ConfirmBox').modal('show');
    return false;

};

warningMsg = function (msg, callback) {
    $("#WarningBox .modal-body>p").html(msg);
    $('#WarningBox').modal('show');
};

successMsg = function (msg, callback) {
    $("#SuccessBox .modal-body>p").html(msg);
    $('#SuccessBox').modal('show');
};

dangerMsg = function (msg, callback) {
    $("#DangerBox .modal-body>p").html(msg);
    $('#DangerBox').modal('show');
};

$(function () {
    $("body").prepend('<div id="MessageBox" class="modal fade" role="dialog">\
    <div class="modal-dialog">\
            <div class="modal-content">\
                <div class="modal-header">\
                    <button type="button" class="close" data-dismiss="modal">&times;</button>\
                    <h4 class="modal-title"></h4>\
                </div>\
                <div class="modal-body">\
                    <p></p>\
                </div>\
                <div class="modal-footer">\
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>\
                </div>\
            </div>\
        </div>\
    </div>');

    $("body").prepend('<div id="WarningBox" class="modal modal-warning fade" id="modal-warning">\
        <div class="modal-dialog">\
        <div class="modal-content">\
        <div class="modal-header">\
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">\
        <span aria-hidden="true">&times;</span></button>\
        <h4 class="modal-title">Warning</h4>\
        </div>\
        <div class="modal-body">\
        <p></p>\
        </div>\
        <div class="modal-footer">\
        <button type="button" class="btn btn-outline pull-right" data-dismiss="modal">Close</button>\
        </div>\
        </div>\
        </div>\
        </div>');

    $("body").prepend('<div id="SuccessBox" class="modal modal-success fade" id="modal-success">\
        <div class="modal-dialog">\
        <div class="modal-content">\
        <div class="modal-header">\
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">\
        <span aria-hidden="true">&times;</span></button>\
        <h4 class="modal-title">Success</h4>\
        </div>\
        <div class="modal-body">\
        <p></p>\
        </div>\
        <div class="modal-footer">\
        <button type="button" class="btn btn-outline pull-right" data-dismiss="modal">Close</button>\
        </div>\
        </div>\
        </div>\
        </div>');

    $("body").prepend('<div id="DangerBox" class="modal modal-danger fade" id="modal-danger">\
        <div class="modal-dialog">\
        <div class="modal-content">\
        <div class="modal-header">\
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">\
        <span aria-hidden="true">&times;</span></button>\
        <h4 class="modal-title">Danger</h4>\
        </div>\
        <div class="modal-body">\
        <p></p>\
        </div>\
        <div class="modal-footer">\
        <button type="button" class="btn btn-outline pull-right" data-dismiss="modal">Close</button>\
        </div>\
        </div>\
        </div>\
        </div>');

    $("body").prepend('<div id="ConfirmBox" class="modal fade" role="dialog">\
    <div class="modal-dialog">\
            <div class="modal-content">\
                <div class="modal-header">\
                    <button type="button" class="close" data-dismiss="modal">&times;</button>\
                    <h4 class="modal-title"></h4>\
                </div>\
                <div class="modal-body">\
                    <p></p>\
                </div>\
                <div class="modal-footer">\
                <a class="btn btn-info btn-ok"  data-dismiss="modal">Yes</a>\
                <button type="button" class="btn btn-default" data-dismiss="modal">No</button>\
                </div>\
            </div>\
        </div>\
    </div>');
});