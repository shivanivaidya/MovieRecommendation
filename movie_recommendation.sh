#Script to execute map-reduce movie recommendation project

# All the following scripts are assumed to be in the libexec folder:
# userRatings.py
# prependAMapper.py
# prependBMapper.py
# identityMapper.py
# ab_join_mapper.py
# prependB2mapper.py
# final_users_all_movies_mapper.py
# final_users_final_movies_mapper.py
# merge_ratings_mapper.py
# difference_squared_reducer.py
# rmse_reducer.py
# rec_users_mapper.py
# rec_movies_mapper.py
# remove_duplicate_reducer.py
# display_movies_mapper.py
# final_rec_movies_mapper.py
# prependB3mapper.py

# movie_recommendation.sh

# All the above mentioned scripts should be executable.
# Can be done by : chmod +x filename.ext

# The input folder in libexec contains u.txt and m.txt.

# the HDFS is empty.

# Execute userRatings.py to input ratings for top 10 movies
# and store the movieIDs and ratings in a file called
# personalRatings.txt in the input folder. Input folder
# already contains the file u.txt.

python3 userRatings.py

# Create a /user directory in hdfs and copy the input folder from 
# the local system to it.

bin/hdfs dfs -mkdir /user
bin/hdfs dfs -put input /user/

# Prepend 'A' to the personalRatings.txt file and output using following format:
# movieID	A	original_rating

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/input/personalRatings.txt" \
        -output "/user/temp/join_a" \
        -mapper prependAMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Prepend 'B' to the u.txt file and output using following format:
# movieID	B	userID	rating

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/input/u.txt" \
        -output "/user/temp/join_b" \
        -mapper prependBMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Join the above two files and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/join_a" \
        -input "/user/temp/join_b" \
        -output "/user/temp/ab_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2

# Generate all the userIDs that have rated some of the top 10 movies same as the original
# user and prepend 'A' to get the following format:
# userID	A

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/ab_join" \
        -output "/user/temp/join_a2" \
        -mapper ab_join_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Prepend 'B' to the u.txt file and output using following format:
# userID	B	movieID	rating 

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/input/u.txt" \
        -output "/user/temp/join_b2" \
        -mapper prependB2Mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Join the above two files and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/join_a2" \
        -input "/user/temp/join_b2" \
        -output "/user/temp/a2b2_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Generate all the movies rated by the final users who have to be considered 
# to calculate the RMS error and prepend 'B' to it. The format is as follows:
# movieID	B	userID	rating

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a2b2_join" \
        -output "/user/temp/final_users_all_movies" \
        -mapper final_users_all_movies_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2

# Join "join_a" and the above file and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/join_a" \
        -input "/user/temp/final_users_all_movies" \
        -output "/user/temp/a3b3_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Generate final userIDs, top 10 movieIDs rated by the final users and their corresponding
# ratings and prepend 'B' to it in the following format:
# movieID	B	userID	rating

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a3b3_join" \
        -output "/user/temp/final_users_final_movies" \
        -mapper final_users_final_movies_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Join the above file with 'join_a' and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/join_a" \
        -input "/user/temp/final_users_final_movies" \
        -output "/user/temp/a4b4_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Mapper: Merge the original user ratings and the other user ratings for the same movies.
# The format is as follows:
# userID	movID	rating	original_rating
# Reducer: Calculates the squared difference between the rating by each user and the 
# rating by the original user for the same movies. It return data in the following format:
# userID	movieID	squared_difference

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a4b4_join" \
        -output "/user/temp/squared_diff_of_ratings" \
        -mapper merge_ratings_mapper.py \
        -reducer difference_squared_reducer.py \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Calculates the rmse values for each userID and outputs in the following format:
# userID	rmse

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/squared_diff_of_ratings" \
        -output "/user/temp/rmse_values" \
        -mapper identityMapper.py \
        -reducer rmse_reducer.py
        
# Generates the userIDs that have 0.000000 rmse values and also prepends 'A' 
# with the following format:
# userID	A

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/rmse_values" \
        -output "/user/temp/rec_users" \
        -mapper rec_users_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer
        
# Join the above file with 'join_b2' and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/rec_users" \
        -input "/user/temp/join_b2" \
        -output "/user/temp/a5b5_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Mapper: Generates the movieIDs that have been rated 5 by the recommended userIDs. 
# It follows the following format:
# movieID
# Reducer: Removes duplicates movieIDs from the movieIDs generated by the mapper and
# also prepends 'B' thus the following format:
# movieID	B

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a5b5_join" \
        -output "/user/temp/rec_movieIDs" \
        -mapper rec_movies_mapper.py \
        -reducer remove_duplicate_reducer.py
        
# Join the above file with 'join_a' and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/join_a" \
        -input "/user/temp/rec_movieIDs" \
        -output "/user/temp/a6b6_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Removes the top ten movieIds from the recommended movieIDs. Also prepends
# 'A'. Format is as follows:
# movieID	A

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a6b6_join" \
        -output "/user/temp/final_rec_movieIDs" \
        -mapper final_rec_movies_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer
        
# Prepend 'B' to the m.txt file and output using following format:
# movieID	B	movieName

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/input/m.txt" \
        -output "/user/temp/join_b3" \
        -mapper prependB3mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer
        
# Join the above file with 'final_rec_movieIDs' and sort.

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/final_rec_movieIDs" \
        -input "/user/temp/join_b3" \
        -output "/user/temp/a7b7_join" \
        -mapper identityMapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
        -jobconf stream.num.map.output.key.fields=2 \
        -jobconf stream.num.reduce.output.key.fields=2
        
# Prints this message.        
echo -e "\nRecommended movies are as follows:\n"

# Generates the movieNames based on the movieIDs. Format is as follows:
# MovieID	MovieName

hadoop jar \share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
        -input "/user/temp/a7b7_join" \
        -output "/user/output/recommended_movies" \
        -mapper display_movies_mapper.py \
        -reducer org.apache.hadoop.mapred.lib.IdentityReducer
        
# Display recommended_movies

bin/hdfs dfs -get /user/output/recommended_movies/ output

head -50 output/*













