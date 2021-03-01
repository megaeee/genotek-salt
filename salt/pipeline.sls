# vim: syntax=yaml  
{{ sls }}. Make git files executable:
  file.directory:
    - name: /mnt
    - file_mode: 777
    - follow_symlinks: True
    - recurse:
      - mode

{% set python_path = salt['environ.get']('PYTHONPATH', '/bin:/usr/bin') %}
{{ sls }}. Run pipeline:
  cmd.run:
    - name: 'python -u /mnt/pipeline.py UniteChipHVS --ExperimentID {{ grains["experiment"]["id"] }} --TelegramQuiet --MemoryLimitPerThread 8g --ShutdownPolicy delete 2>&1 | tee -a /mnt/tmp/log.UniteChipHVS.log'
    - env:
      - LD_LIBRARY_PATH: /usr/lib
      - PERL5LIB: /mnt/db/tools/mitoSeek:/mnt/db/tools/mitoSeek/Resources/circos-0.56/bin
      - PYTHONPATH: {{ [python_path, '/mnt']|join(':') }}
