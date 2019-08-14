function [XYZ] = Rot_pose_motor(yaw,px,py)

yaw = yaw*180/pi ;

M_rotacao = [cosd(yaw) -sind(yaw) 0; sind(yaw) cosd(yaw) 0; 0 0 1];

XYZ = M_rotacao * ([px ;py ; 0]);
end