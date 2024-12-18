function sendToKitchen(orderDetails) {
    console.log("Order details before sending to kitchen:", orderDetails);
    // ...existing code to send order details to kitchen...
    console.log("Order details after sending to kitchen:", orderDetails);
}

// Ensure that order details are not removed from the data structure
function maintainOrderDetails(orderDetails) {
    // ...existing code...
    sendToKitchen(orderDetails);
    // Ensure orderDetails are still intact
    console.log("Order details after maintaining:", orderDetails);
}
