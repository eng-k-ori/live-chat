# 1 適宜変更
du:
	docker-compose up --force-recreate

db:
	docker-compose build

dbn:
	docker-compose build --no-cache

duf:
	docker-compose up --force-recreate

dpb:
	docker-compose -f docker-compose.prod.yml build

dpbn:
	docker-compose -f docker-compose.prod.yml build --no-cache

dsp:
	docker system prune

# @          @@          @@          @@          @@          @@          @@          @
# 1
# {簡略化コマンド}:
# 	{実行コマンド(コマンドは1つ以上)}
# make {簡略化コマンド}