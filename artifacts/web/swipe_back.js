//function handleTouchMove(event, xStart, yStart) {
//  var xDiff = xStart - event.touches[0].pageX;
//  var yDiff = yStart - event.touches[0].pageY;
//
//  // Detect right swipe
//  if (xDiff < -20 && Math.abs(xDiff) > Math.abs(yDiff)) {
//    event.preventDefault();
//    history.back(); // Navigate to the previous page
//  }
//}
//
//var newHandleTouchMove = function (xStart, yStart) {
//  return function (event) {
//    handleTouchMove(event, xStart, yStart);
//  };
//}
//
//document.addEventListener('touchstart', function (startEvent) {
//  // Ignore multi-touch gestures
//  if (startEvent.touches.length > 1) {
//    return;
//  }
//
//  var xStart = startEvent.touches[0].pageX;
//  var yStart = startEvent.touches[0].pageY;
//
//  // Attach the touchmove event listener
//  document.addEventListener('touchmove', newHandleTouchMove(xStart, yStart), { passive: false });
//}, { passive: false });
