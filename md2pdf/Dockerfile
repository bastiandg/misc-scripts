FROM pandoc/latex:2.16.2

RUN tlmgr update --package-logfile /dev/null --command-logfile /dev/null --self --all && \
    tlmgr install --package-logfile /dev/null --command-logfile /dev/null \
                sourcecodepro \
                bera \
                fontaxes \
                ly1 && \
    tlmgr backup --clean --all --clean=0
