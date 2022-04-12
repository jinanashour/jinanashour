#include <iostream>
#include <thread>
#include<string>
#include<fstream>
#include<vector>
#include<algorithm>

using namespace std;


void function1(vector<vector<int>> p , int cs) {
	sort(p.begin(), p.end(), sortcol); //sorting depending on arrival time
	int time_until_now = p[0][2]+p[0][1];//finish time for the first coming process= arrival+burst
	vector<int>GanttChart(p.size());
	GanttChart.push_back(time_until_now); // first process enters gantt chart
	for (int i = 1; i < p.size(); i++)//excuting remaining processes and adding them to gantt chart
	{
		time_until_now += cs;
		time_until_now += p[i][2]; // adding the burst time of next process (excuting it)
		GanttChart.push_back(time_until_now); // adding finish time of this process to gantt chart
	}
	//now gantt chart is ready .. 
	//1-finish time:
	//finish time already exists in gantt chart so we will directly print them:
	vector<string>finish_time(p.size());
	for (int i = 0; i < p.size(); i++) {
		string s = "finish time for process " + p[i][0];
		s += " is : "+GanttChart[i];
		s += "\n";
		finish_time.push_back(s);
	}

	
		//2-waiting time for each process:
		vector<string>waiting_time(p.size());
	//it equals: starting(previous process finish time+cs) - arrival time
	for (int i = 0; i < p.size(); i++) {
		if (i == 0) {
			string s = "waiting time for process " + p[i][0];
			s += " is : 0 ";
			waiting_time.push_back(s);
			//cout << "waiting time for process " << p[i][0] << " is : " << 0 << endl;
		}
		else
		{
			string s = "waiting time for process " + p[i][0]; 
			s += " is : ";
			s += (GanttChart[i - 1] + cs) - p[i][1];
			waiting_time.push_back(s);
			//cout << "waiting time for process " << p[i][0] << " is : " << (GanttChart[i - 1] + cs) - p[i][1] << endl;
		}
	}

}


void function2() {

}


void function3() {

}

bool sortcol(const vector<int>& v1 , const vector<int>& v2) {
	return v1[1] > v2[1];
}

int main() {
	ifstream fin;
	fin.open("processes.txt");
	//read file
	long long memory_size, page_size;
	int round_robin_q, context_switch;
	fin >> memory_size >> page_size >> round_robin_q >> context_switch;
	vector<vector<int>> procceses; // main array that contains all process datails


	while (!fin.eof()) { // reading PCB details
		vector<int> v(4); //temp vector to append to the end of the first vector
		//fin >> id >> arrival_time >> cpu_burst >> size; OR:
		fin >> v[0] >> v[1] >> v[2] >> v[3];
		procceses.push_back(v);
	}


	fin.close();

	//first thread -for fisrt come first serve algo
	thread FCFS(function1,procceses,context_switch);

	//second thread -for shortest job first algo
	thread SJF(function2);

	//third thread -for round robin algo
	thread RR(function3);

	return 0;



}
