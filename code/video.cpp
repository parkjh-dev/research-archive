 // g++ -o opencv opencv.cpp -lopencv_highgui -lopencv_imgproc -lopencv_core -lwiringPi -lm
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#include <stdlib.h>
#include <cmath>
#include <iostream>
#include <fstream>
#include <time.h>
#include <unistd.h>
#include <wiringPi.h>
#include <wiringPiI2C.h>
#include <math.h>


using namespace cv;
using namespace std;
#define PI 3.141592;
#define DT 0.001

// mpu6050

// gyro
int GYRO_X, GYRO_Y, GYRO_Z, ACCEL_X, ACCEL_Y, ACCEL_Z;
double G_RE_X, G_RE_Y, G_RE_Z, A_RE_X, A_RE_Y, A_RE_Z, ACCX, ACCY, ACCZ, GYROX, GYROY, GYROZ, XANGLE, YANGLE, ZANGLE;
int sensor;
int posture; //자세


double GYRO_Change(int data) // Two's complement
{
	if( data >= 32786) {

		data = ( (data ^ 0xFFFF) ) * -1;
		return data;
	}

	else
		return data;
}

double ACCEL_Change(int data) // Two's complement
{
	if( data >= 35500) {

		data = ( (data ^ 0xFFFF) ) * -1;
		return data;
	}

	else
		return data;

}
void mpu6050_data_read() {
	// gyro code
	GYRO_X = wiringPiI2CReadReg8(sensor, 0x43);
	GYRO_X = GYRO_X << 8 | wiringPiI2CReadReg8(sensor, 0x44); // GYRO X
	G_RE_X = GYRO_Change(GYRO_X);

	GYRO_Y = wiringPiI2CReadReg8(sensor, 0x45);
	GYRO_Y = GYRO_Y << 8 | wiringPiI2CReadReg8(sensor, 0x46); // GYRO Y
	G_RE_Y = GYRO_Change(GYRO_Y);

	GYRO_Z = wiringPiI2CReadReg8(sensor, 0x47);
	GYRO_Z = GYRO_Z << 8 | wiringPiI2CReadReg8(sensor, 0x48); // GYRO Z
	G_RE_Z = GYRO_Change(GYRO_Z);

	ACCEL_X = wiringPiI2CReadReg8(sensor, 0x3B);
	ACCEL_X = ACCEL_X << 8 | wiringPiI2CReadReg8(sensor, 0x3C); // ACC X
	A_RE_X = ACCEL_Change(ACCEL_X);

	ACCEL_Y = wiringPiI2CReadReg8(sensor, 0x3D);
	ACCEL_Y = ACCEL_Y << 8 | wiringPiI2CReadReg8(sensor, 0x3E); // ACC Y
	A_RE_Y = ACCEL_Change(ACCEL_Y);

	ACCEL_Z = wiringPiI2CReadReg8(sensor, 0x3F);
	ACCEL_Z = ACCEL_Z << 8 | wiringPiI2CReadReg8(sensor, 0x40); // ACC Z
	A_RE_Z = ACCEL_Change(ACCEL_Z);


	ACCY = atan2(A_RE_Z, A_RE_X) * 180 / PI;
	ACCX = atan2(A_RE_Z, A_RE_Y) * 180 / PI;
	ACCZ = atan2(A_RE_Y, A_RE_X) * 180 / PI;

	GYROX = (double)G_RE_X / 131.0;
	GYROY = (double)G_RE_Y / 131.0;
	GYROZ = (double)G_RE_Z / 131.0;

	//Complimentary filter
	XANGLE = (0.95 * (XANGLE + (GYROX * DT)) + (0.05 * ACCX));
	YANGLE = (0.95 * (YANGLE + (GYROY * DT)) + (0.05 * ACCY));
	ZANGLE = (0.95 * (ZANGLE + (GYROZ * DT)) + (0.05 * ACCZ));


		if(((XANGLE >= 140 && XANGLE <= 180) || (XANGLE <= -145 && XANGLE >= -180)) && ((YANGLE >= 110 && YANGLE <= 180) || (YANGLE <= -100 && YANGLE >= -180)))
		{
			cout << "right\n" << endl;
			posture = 1;
		}else if ((XANGLE <= -3 && XANGLE >= -60) && ((YANGLE >= 110 && YANGLE <= 180) || (YANGLE <= -100 && YANGLE >= -180)))
		{
			cout << "left\n" << endl;
			posture = -1;
		}
		else
		{
			cout << "centor\n" << XANGLE << ", " << YANGLE  << endl;
			posture = 0;
		}
		// gyro code end


//	printf("XANGLE : %lf\t YANGLE : %10lf\tZANGLE : %10lf\n", XANGLE, YANGLE, ZANGLE);
}




std::vector<std::vector<cv::Point> > contours;
ofstream outFile("testoutput.txt");
time_t start_p, end_p;
int prex, prey;
int iSliderValue1 = 265;
int iSliderValue2 = 300;
int total, cnt;
int size;
int check = 0;

cv::Mat process(const cv::Mat &image)
{
	int check = 0;
	total++;
	// 변수 선언
	cv::Mat gray, gray2;
	cv::Mat src, temp;
	src = image;

	// 관심영역 생성
	//Rect roi = Rect(250, 200, 250, 250);
	Rect roi = Rect(80, 100, 350, 350);

	//Rect roi2 = Rect(600, 120, 150, 150);
	//rectangle(src, cvPoint(250,200), cvPoint(400, 350),CV_RGB(0, 0, 255), 4);	
	//rectangle(src, cvPoint(175,125), cvPoint(415, 355),CV_RGB(0, 0, 255), 4);

	if (src.empty())
		return src;

	// 관심영역 설정
	Mat sub_src = src(roi);
	//Mat sub_src2 = src(roi2);


	cv::imshow("roi", sub_src);
	//cv::imshow("roi2", sub_src2);

	// 컬러모델 변경 
	// RGB -> GRAY로 변경
	cvtColor(sub_src, temp, CV_BGR2GRAY);

	// 트랙바 생성
	createTrackbar("BINARY1", "MyVideo", &iSliderValue1, 500);
	//createTrackbar("BINARY2", "MyVideo", &iSliderValue2, 500);

	int iBinary1 = iSliderValue1 - 50;
	int iBinary2 = iSliderValue2 - 50;

	// 이진화
	cv::threshold(~temp, gray, iBinary1, iBinary2, cv::THRESH_BINARY);

	//cv::imshow("Binary", gray);

	// 모폴로지 연산
	// 노이즈 제거에 사용
	cv::erode(gray, gray, cv::Mat(), Point(-1, -1), 8);
	cv::dilate(gray, gray, cv::Mat(), Point(-1, -1), 6);
	//GaussianBlur(gray, gray, Size(7, 7), 1, 5);

	// Find all contours
	//외곽선 검출
	cv::findContours(gray.clone(), contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

	// Fill holes in each contour
	// 외곽선 채우기
	cv::drawContours(gray, contours, -1, CV_RGB(255, 255, 255), -1);

	cv::imshow("res", gray);

	end_p = clock();
	double temp1 = ((double)end_p - start_p) / 1000000;

	//if(contours.size() == 0)
	//	iSliderValue1--;
	//else if(contours.size() >= 2)
	//	iSliderValue1++;
	//else{
	
	for (int i = 0; i < contours.size(); i++)
	{
		check = 1;
		double area = cv::contourArea(contours[i]);
		cv::Rect rect = cv::boundingRect(contours[i]);
		int radius = rect.width / 2;
		int radius2 = rect.height / 2;
		int h, w;
		double dis, ang;

		
		

		// If contour is big enough and has round shape
		// Then it is the pupil
		if (area >= 30 &&
			std::abs(1 - ((double)rect.width / (double)rect.height)) <= 0.6 &&
			std::abs(1 - (area / (CV_PI * std::pow(radius, 2)))) <= 0.6 && radius > 20 && radius < 90)
		{
			cnt++;
			cv::circle(src, cv::Point(roi.x + rect.x + radius, roi.y + rect.y + radius), radius, CV_RGB(255, 0, 0), 2);
			//cout << roi.x + rect.x << " " << roi.y + rect.y << endl;// 좌 표

			//cv::circle(src, cv::Point(roi.x + rect.x + radius, roi.y + rect.y + radius2), 1, CV_RGB(255, 0, 0), 2);
			//cout << temp << " " << "(" << " " << rect.x + radius << "," << rect.y + radius2 << ")" << "(" << prex << "," << prey << ")";

			//거리
			dis = sqrt(pow(prex - (rect.x + radius), 2) + pow(prey - (rect.y + radius2), 2));

			//각도
			ang = atan2(prey - (rect.y + radius2), prex - (rect.x + radius)) * 180 / PI;

			//outFile << dis << " " << temp << " " << dis << " " << prex << " " << prey;

			//outFile << prex << " " << prey << " " << dis << " " << ang <<endl;
			
			prex = rect.x + radius;
			prey = rect.y + radius2;
			outFile << temp1 << " " << prex << " " << prey << " " << posture << endl;
			size = radius;
			//outFile << temp1 << " " << size << endl;
		}
		else
		{
			prex = -1;
			prey = -1;
			outFile << temp1 << " " << prex << " " << prey << " " << posture << endl;
		}
	
	}
	if(check == 0)
	{
		prex = -1;
		prey = -1;
		outFile << temp1 << " " << prex << " " << prey << " " << posture << endl;
	}

	//cout << temp1 << endl;
	//outFile << temp1 << " " << size << endl;
	check = 0;
	return src;
}






int main(int argc, char** argv)
{
	//system("uv4l --driver raspicam --auto-video_nr --width 640 --height 480 --encoding jpeg --frame-time 0");
	system("uv4l --driver raspicam --width 320 --height 240 --auto-video_nr --nopreview");
	sleep(2);
	VideoCapture vc ("a.mp4");
	
	start_p = clock();	

	if (!vc.isOpened())  // if not success, exit program
	{
		return -1;
	}

	double fps = vc.get(CV_CAP_PROP_FPS); //get the frames per seconds of the video

	namedWindow("MyVideo", CV_WINDOW_AUTOSIZE); //create a window called "MyVideo"
// gyro
	

	sensor = wiringPiI2CSetup(0x68);

	wiringPiI2CWriteReg8(sensor, 0x6B, 0);
	wiringPiI2CWriteReg8(sensor, 27, 0x00);

// gyro
	while (1)
	{
		mpu6050_data_read();



		Mat frame;
		bool bSuccess = vc.read(frame); // read a new frame from video

		if (!bSuccess) //if not success, break loop
		{
			break;
		}


		frame = process(frame);

		imshow("MyVideo", frame); //show the frame in "MyVideo" window
		//resize(sub, sub, Size(400, 300));
		//imshow("MyVideo", sub); //show the frame in "MyVideo" window
		if (waitKey(30) == 27) //wait for 'esc' key press for 30 ms. If 'esc' key is pressed, 
		{
			cout << total << " " << cnt << endl;
			break;
		}




	}

	//waitKey(0);
	outFile.close();

	return 0;
}