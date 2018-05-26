# MovieRecommendation



1) install homebrew
2) install hadoop :

brew install hadoop

3) from libexe : 
bin/hadoop

Hadoop Commands:

hadoop fs -rm -r /user/shivanivaidya/input

To find hadoop-streaming jar path:

find / -name "hadoop*streaming*" -print

For hadoop-streaming:

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar -input "/user/shivanivaidya/books/*" -output "/user/shivanivaidya/output" -mapper mapper.py -reducer reducer.py -file "code/mapper.py" -file "code/reducer.py" 

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar -input "/user/shivanivaidya/input/u.txt” -output "/user/shivanivaidya/temp” -mapper movie_mapper1.py -reducer movie_reducer1.py

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar -input “/user/shivanivaidya/input/personalRatings.txt” -output "/user/shivanivaidya/temp” -mapper prependAMapper.py -reducer org.apache.hadoop.mapred.lib.IdentityReducer

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar -input "/user/shivanivaidya/input/personalRatings.txt" -output "/user/shivanivaidya/temp/join_a" -mapper prependAMapper.py -reducer org.apache.hadoop.mapred.lib.IdentityReducer -jobconf stream.num.map.output.key.fields=2 -jobconf stream.num.reduce.output.key.fields=2
