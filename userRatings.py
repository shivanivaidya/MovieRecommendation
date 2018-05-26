
''' This script asks the user to enter the ratings of the following 10 movies and stores them in a file
personalRatings.txt in the format:

movieID::rating'''


topMovies = """1,Toy Story (1995)
780,Independence Day (a.k.a. ID4) (1996)
590,Dances with Wolves (1990)
1210,Star Wars: Episode VI - Return of the Jedi (1983)
648,Mission: Impossible (1996)
344,Ace Ventura: Pet Detective (1994)
165,Die Hard: With a Vengeance (1995)
153,Batman Forever (1995)
597,Pretty Woman (1990)
1580,Men in Black (1997)
231,Dumb & Dumber (1994)"""

def get_user_ratings():
    prompt = "Please rate the following movie (1-5 (best), or 0 if not seen): "
    print (prompt)

    n = 0

    f = open("input/personalRatings.txt", 'w')
    for line in topMovies.split("\n"):
        ls = line.strip().split(",")
        valid = False
        while not valid:
            rStr = input(ls[1] + ": ")
            r = int(rStr) if rStr.isdigit() else -1
            
            if r < 0 or r > 5:
                print (prompt)
            else:
                valid = True
                if r > 0:
                    f.write("%s\t%d\n" % (ls[0], r))
                    n += 1
    f.close()
        
get_user_ratings()
