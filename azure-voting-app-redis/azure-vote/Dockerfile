FROM tiangolo/uwsgi-nginx-flask:python3.6
ENV REDIS=azure-vote-back
RUN pip install redis
ADD /azure-vote /app
