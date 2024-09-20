#! /bin/bash -v
#sleep 5
end=$((SECONDS+10))
counter=0
#URL="http://34.134.227.5:8080" # ext ip with load balancer
URL="http://34.118.231.172:8080" # cluster ip
while [ $SECONDS -lt $end ]; do
    # By default curl will do a GET 
    # -s supress the progres bar
    # -o /dev/null supresses the response so it doesn't spam the screen with HTML
    # curl cheat sheet: https://devhints.io/curl
    ((counter++))
    current_date_time="`date +%Y%m%d%H%M%S`";
    echo Loop number $counter
    echo $current_date_time;

    # Home page
    curl -s -o /dev/null ${URL};

    # Owners...
    #echo 
    curl -s -o /dev/null ${URL}"/owners/find";
    curl -s -o /dev/null ${URL}"/owners?lastName="
    curl -s -o /dev/null ${URL}"/owners/new"
    curl -s -o /dev/null ${URL}"/owners/new"
    curl -s -o /dev/null -X POST -d "firstName=John&lastName=Smith&address=123+Main+St&city=Lexington&telephone=5555555555" ${URL}"/owners/new"

    # Vets
    curl -s -o /dev/null ${URL}"/vets.html";

    # Error page
    curl -s -o /dev/null ${URL}"/oups";
done 
