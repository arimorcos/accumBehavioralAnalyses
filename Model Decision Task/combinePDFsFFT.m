function out = combinePDFsFFT(pdf1, pdf2)

pdf1FFT = fft(pdf1);
pdf2FFT = fft(pdf2);
combPDFFFT = pdf1FFT.*pdf2FFT;
out = fftshift(ifft(combPDFFFT));