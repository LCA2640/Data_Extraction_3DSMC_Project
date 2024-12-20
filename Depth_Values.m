% Define the data path and the file name
data_path = '../';
sample_name = 'image00022'; % Change to your file name

% Load the image
img = imread([data_path sample_name '.jpg']); 

% Load the data from the .mat file
data = load([data_path sample_name '.mat']);

% Get the 3D points (pt3d_68) from the loaded data
pt3d_68 = data.pt3d_68; % 3D points (3x68)

% Extract the depth values (Z coordinates)
depth_values = pt3d_68(3, :); % Depth values are in the Z-coordinate (3rd row)

% Define the save path and the file name for depth values
output_file = 'D:\Escuela\TUM\WISE_24-25\3D-Scanning\Proyecto_FaceRecon_Dataset\AFLW2000\Code\DepthValues.txt';

% Open the file for writing
fileID = fopen(output_file, 'w');

% Write the header
fprintf(fileID, 'Depth Values for Landmarks (in mm)\n\n');

% Loop through the landmarks and write the depth value for each one
for i = 1:length(depth_values)
    fprintf(fileID, 'Landmark %d: %.4f mm\n', i, depth_values(i)); % Write each landmark and its depth value
end

% Close the file
fclose(fileID);

disp(['Depth values saved in: ' output_file]);
