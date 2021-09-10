#This script is used for automatically submit jobs.
cd /xdisk/denard/cdi/thermonet/
cd $1
limit=500

for i in {1..4000}
do
	echo $i
	num2=$(squeue -u cdi| wc -l)
	echo $num2
	rm tosub
	ls *.slurm> tosub
	ltosub="$(cat tosub| wc -l)"
	echo $ltosub
#You have to keep the space in the if condition [(space)$ltosub(space)=(space)0(space)]
if [ $ltosub = 0 ];then 
	echo "All the jobs have been submitted."
	break
elif [ $num2 = 500 ];then
	echo Full of job queue list.T-T
	echo Wait for 1min.
	sleep 1m
else
	rm temp*
	num1=500
	echo Maxjobs:$num1 minus running jobs:$num2
	n="$((num1-num2))"
	if ((ltosub > n)) ;then
		echo submit $n jobs to hpc.
		head -$n tosub > temp
		#sed 's/^/echo /' temp >temp.bash
		#sed 's/^/qsub /' temp >temp.bash
		sed 's/^/sbatch /' temp >temp.bash
		sed 's/^/rm /' temp >tempremove.bash
		chmod +x temp.bash
		head -1 temp.bash
		./temp.bash
		chmod +x tempremove.bash
		./tempremove.bash
		rm temp*
	else
		echo Last submission for this round.
		#sed 's/^/echo /' tosub >temp.bash
		#sed 's/^/qsub /' tosub >temp.bash
                sed 's/^/sbatch /' tosub >temp.bash
		chmod +x temp.bash
		head -1 temp.bash
                ./temp.bash
		sed 's/^/rm /' tosub >tempremove.bash
                chmod +x tempremove.bash
                ./tempremove.bash
		rm temp*
	fi
fi
done
