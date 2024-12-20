% Define the data path and the file name
data_path = '../';
sample_name = 'image00022'; % Change to your file name

% Load the image
img = imread([data_path sample_name '.jpg']); 

% Get the dimensions of the image
[height, width, nChannels] = size(img); 

% Define the save path and the file name for RGB data
output_file = 'D:\Escuela\TUM\WISE_24-25\3D-Scanning\Proyecto_FaceRecon_Dataset\AFLW2000\Code\RGBData.txt';

% Open the file for writing
fileID = fopen(output_file, 'w');

% Write the header with clarification
fprintf(fileID, 'RGB Data for each pixel\n\n');
fprintf(fileID, 'Image Dimensions: Height = %d, Width = %d\n\n', height, width);

% Loop through all pixels and write the RGB values
for i = 1:height
    for j = 1:width
        % Get the RGB values for the pixel at position (i, j)
        R = img(i, j, 1); % Red channel
        G = img(i, j, 2); % Green channel
        B = img(i, j, 3); % Blue channel
        
        % Write the pixel index and its RGB values
        fprintf(fileID, 'Pixel (%d, %d): R=%d, G=%d, B=%d\n', i, j, R, G, B);
    end
end

% Close the file
fclose(fileID);

disp(['RGB data saved in: ' output_file]);
