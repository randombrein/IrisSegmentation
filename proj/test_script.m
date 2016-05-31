%% test image segmentation
%
% segments a image ('test.jpg') and shows marked segmentation using `segmentopt`
% rmin,rmax params. are calculated accordingly 
% (after analyzing the dataset values seems reasonable)
I = imread('test.jpg');
rmin = min(size(I, 1), size(I,2)) / 5; % rmin value (reasonable)
rmax = max(size(I, 1), size(I,2)) / 3 * 2; % rmax value (reasonable)
[ci,cp,out] = segmentopt(I,rmin,rmax);
imshow(out);


%% imfill output of test image
%
% imfill output of test image with negative versions of the image using `imcomplement`
% which demonstrates morphological enhancement of the matlab func. `imfill` to bypass 
% specular reflections in an image
I = imread('test.jpg');
subplot(2,2,1), imshow(I);
subplot(2,2,2), imshow(imcomplement(I));
subplot(2,2,3), imshow(imfill(imcomplement(I), 'holes'));
subplot(2,2,4), imshow(imcomplement(imfill(imcomplement(I), 'holes')));


%% process dataset for iris images and write output images to same folders
%
% enumares asssets' root directory and processes first images in subfolders
% after the process (with `segmentopt` func.) writes output image to the same folder
%  
sep = filesep;
root = ['..' sep 'assets' sep 'Sessao_1']; % root directorys
list = dir(root);
% sub folders paths
dirnames = {list([list.isdir]).name};
dirnames = dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));
folders = strcat(root, sep, dirnames);

runtime = 0; 
% enumarete each subfolder
for i=1:length(folders)
    folder = char(folders(i));
    filelist = dir(folder);
    filenames = {filelist(~[filelist.isdir]).name};
    for j=1:length(filenames)
        firstfile = char(strcat(folder, sep, filenames(j)));
        [pathstr,name,ext] = fileparts(firstfile);
        % subfolder has an image folder
        % process the image and write output
        % while keeping runtime
        if strcmpi(ext, '.jpg') || strcmpi(ext, '.png')
            fprintf('Segmenting "%s"\n', firstfile);

            I = imread(firstfile);
            rmin = min(size(I, 1), size(I,2)) / 5; % rmin value (reasonable)
            rmax = max(size(I, 1), size(I,2)) / 3 * 2; %rmax value (reasonable)
            tic
            [ci,cp,out] = segmentopt(I,rmin,rmax);
            t = toc;
            fprintf('Elapsed time is %.6f seconds\n', t);
            runtime = runtime + t;
            
            imwrite(out, fullfile(pathstr,[name '_out' ext]));
            break; % first file segmented
        end
    end
end
fprintf('Total runtime: "%.2f seconds"\n', runtime);



