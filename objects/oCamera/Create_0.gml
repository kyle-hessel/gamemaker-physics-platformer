/// @description init camera variables

defaultCam = view_camera[0];
objectFollow = oPlayer;

viewWidthHalf = camera_get_view_width(defaultCam) * VIEW_HALF;
viewHeightHalf = camera_get_view_height(defaultCam) * VIEW_HALF;

xTo = xstart;
yTo = ystart;