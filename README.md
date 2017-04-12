# wanikani-stats
A rails application for managing WaniKani user statistics.  
App preview: http://kanji.hedona.pl/  
Setup requires:
1. Adding personal WaniKani API key as WANIKANI_API_KEY env variable, for example `export WANIKANI_API_KEY="secret"`
2. Running `whenever --update-crontab` to create an hourly cron task for generating new logs

To run logs generation task manually, click refresh button on characters list or visit /logs/generate url.