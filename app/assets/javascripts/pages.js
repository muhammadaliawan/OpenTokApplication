$(document).ready(function() {
  var api_key = gon.api_key;
  var sessionID = gon.sessionID;
  var token = gon.token;
  var session;
  var publisher;

  OT.setLogLevel(OT.DEBUG);
    var session = OT.initSession(sessionID);
    session.addEventListener('sessionConnected', sessionConnectedHandler);
    session.addEventListener('streamCreated', streamCreatedHandler);
    session.connect(api_key, token);

  function sessionConnectedHandler(event) {
    publisher = OT.initPublisher(api_key, 'videobox');
    session.publish(publisher);

    subscribeToStreams(event.streams);
  }

  function streamCreatedHandler(event) {
    subscribeToStreams(event.streams);
  }

  function subscribeToStreams(streams) {
    for (var i = 0; i < streams.length; i++) {
      if (streams[i].connection.connectionId == session.connection.connectionId) {
        return;
      }

      var div = document.createElement('div');
      div.setAttribute('id', 'stream' + streams[i].streamId);
      document.body.appendChild(div);

      session.subscribe(streams[i], div.id);
    }
  }

  function endStream() {
    OT.connections.forceDisconnect(session.sessionId, session.connection.connectionId)
  }
});
