clc; clear; close all; warning off all;

%%% Pelatihan
% Menetapkan lokasi folder data latih
nama_folder = 'data latih';
% Membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
% Membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);

% Menginisialisasi variabel data_latih dan kelas_latih
data_latih = zeros(jumlah_file, 2);
kelas_latih = cell(jumlah_file, 1);

% Melakukan pengolahan citra terhadap seluruh file
for n = 1:jumlah_file
    % Membaca file citra rgb
    Img = imread(fullfile(nama_folder, nama_file(n).name));
  %  figure, imshow(Img)
    % Melakukan konversi citra rgb menjadi citra L*a*b
    cform = makecform('srgb2lab');
    lab = applycform(Img, cform);
 %   figure, imshow(lab)
    % Mengekstrak komponen dari citra L*a*b
    a = lab(:,:,2);
 %   figure, imshow(a)
    % Melakukan thresholding terhadap komponen a
    bw  = a > 140;
 %   figure, imshow(bw)
    % Melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
    bw = imfill(bw,'holes');
 %   figure, imshow(bw)
    % Mengkonversi citra rgb menjadi citra hsv
    hsv = rgb2hsv(Img);
    % Mengekstrak komponen h dan s dari citra hsv
    h = hsv(:,:,1); %Hue
    s = hsv(:,:,2); %Saturasi
    % Mengubah nilai piksel background menjadi nol
    h(~bw) = 0;
    s(~bw) = 0;
    % Menghitung rata-rata nilai hue dan saturasi
    data_latih(n,1) = sum(sum(h))/sum(sum(bw));
    data_latih(n,2) = sum(sum(s))/sum(sum(bw));
end

% Menetapkan kelas latih
for k = 1:15
    kelas_latih{k} = 'apel';
end

for k = 16:25
    kelas_latih{k} = 'jeruk';
end

% Melakukan pelatihan menggunakan algoritma LDA
Mdl = fitcdiscr(data_latih, kelas_latih);

% Membaca kelas keluaran hasil pelatihan
kelas_keluaran = predict(Mdl, data_latih);

% Menghitung nilai akurasi pelatihan 
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(kelas_keluaran{k}, kelas_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end    
 
akurasi_pelatihan = jumlah_benar/jumlah_file * 100

save Mdl Mdl