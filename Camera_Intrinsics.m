% Define the data path and the file name
data_path = '../';
sample_name = 'image00022'; % Change to your file name

% Load the image
img = imread([data_path sample_name '.jpg']); 

% Load the data from the .mat file
data = load([data_path sample_name '.mat']);

% Display the dimensions of the loaded variables
vars = fieldnames(data); % Get the variable names from the .mat file
disp('Dimensions of the loaded variables:');
for i = 1:length(vars)
    var_name = vars{i}; % Variable name
    var_value = data.(var_name); % Access the variable value
    disp([var_name, ': ', num2str(size(var_value))]); % Show size
end

% Get the 3D and 2D points
pt3d_68 = data.pt3d_68; % 3D points (3x68)
pt2d = data.pt2d; % 2D points (2x21)

% Make sure there are enough points for estimation (at least 6 points)
num_points = size(pt2d, 2); % Number of 2D points

if num_points < 6
    error('At least 6 points are needed for camera estimation.');
end

% For camera estimation, we select the first 6 points (this is an example)
% You can select other points if needed
selected_2d = pt2d(:, 1:6); % First 6 2D points
selected_3d = pt3d_68(:, 1:6); % First 6 3D points

% Prepare object and image matrices
object_points = selected_3d'; % 3D points (Nx3)
image_points = selected_2d'; % 2D points (Nx2)

% Build the matrix A (2*N x 12)
A = [];
for i = 1:size(object_points, 1)
    X = object_points(i, 1); % X coordinate of the 3D point
    Y = object_points(i, 2); % Y coordinate of the 3D point
    Z = object_points(i, 3); % Z coordinate of the 3D point
    x = image_points(i, 1); % x coordinate of the 2D point
    y = image_points(i, 2); % y coordinate of the 2D point
    
    % Correspondence matrix A (each row represents one equation)
    A = [A; 
         X, Y, Z, 1, 0, 0, 0, 0, -x*X, -x*Y, -x*Z, -x;
         0, 0, 0, 0, X, Y, Z, 1, -y*X, -y*Y, -y*Z, -y];
end

% Solve the system Ax = 0 using SVD
[~, ~, V] = svd(A);
P = V(:, end); % The solution vector is the last column of V

% Estimate the 3x4 projection matrix
P = reshape(P, 4, 3)'; % 3x4 projection matrix

% Estimate the intrinsic matrix from the projection matrix
K = P(:, 1:3); % The first three parameters define the intrinsic matrix

% Display the intrinsic matrix
disp('Estimated Intrinsic Matrix:');
disp(K);

% Define the save path and the file name
output_file = 'D:\Escuela\TUM\WISE_24-25\3D-Scanning\Proyecto_FaceRecon_Dataset\AFLW2000\Code\Intrinsics.txt';

% Save the intrinsic parameters to a .txt file
fileID = fopen(output_file, 'w');
fprintf(fileID, 'Camera Intrinsics Matrix:\n');
fprintf(fileID, '%f %f %f\n', K');
fclose(fileID);

disp(['Intrinsic parameters saved in: ' output_file]);
