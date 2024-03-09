clear;

inputFilename = 'scope-0.bin';
[t, sig1] = importAgilentBin(inputFilename, 1);
[~, sig2] = importAgilentBin(inputFilename, 2);
[~, sig3] = importAgilentBin(inputFilename, 3);
[~, sig4] = importAgilentBin(inputFilename, 4);
[~, sig5] = importAgilentBin(inputFilename, 5);
[~, sig6] = importAgilentBin(inputFilename, 6);

figure;
plot(t, sig1);
hold on;
plot(t, sig2);
plot(t, sig3);
plot(t, sig4);
hold off;

figure;
plot(t, sig5);
hold on;
plot(t, sig6);
hold off;
