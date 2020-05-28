FROM mcr.microsoft.com/azure-functions/powershell:2.0

RUN apt-get update && apt-get install --no-install-recommends -y mysql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV MYSQLDUMP_OPTIONS --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
