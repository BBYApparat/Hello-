$(document).ready(function(){
    var socket;
    window.addEventListener("message", function(e){
        var event = e.data.event;
        if(event == "connect"){
            console.log("Connecting to socket");
            // Sử dụng https thay vì http
            socket = io("http://localhost:3001"); 

            socket.on("syncEntity", function(data){
                $.post("https://rep-weed/syncEntity", data);
            });
            socket.on("deleteEntity", function(index){
                $.post("https://rep-weed/deleteEntity", JSON.stringify({index: index}));
            });
            socket.on("connect", ()=>{
                console.log("Connect successful");
            });
            socket.on('REGISTER_DATASET', ({name, data})=>{
                $.post("https://rep-weed/REGISTER_DATASET", JSON.stringify({
                    name,  data
                }));
            });
            socket.on('SYNC_DATASET', ({name, index, index2, data})=>{
                $.post("https://rep-weed/SYNC_DATASET", JSON.stringify({
                    name, index, index2, data
                }));
            });
            socket.on('REMOVE_DATASET', ({name, index})=>{
                $.post("https://rep-weed/REMOVE_DATASET", JSON.stringify({
                    name, index
                }));
            });
            socket.on('UPDATE_DATASET', ({data})=>{
                $.post("https://rep-weed/UPDATE_DATASET", JSON.stringify({
                    data
                }));
            });
            socket.on('connect_error', function(err) {
                console.log("Connect Error. Reason: ", err);
                socket.disconnect();
            });
        }
    });
});
