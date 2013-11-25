class zurmo::database::mysql_server {
  class { 'mysql::server':
		override_options => {
			'mysql' => {
				'default-character-set' => 'utf8',
			},
			'mysqld' => {
				'character-set-server' => 'utf8',
				'collation-server' => 'utf8_unicode_ci',
				'max_allowed_packet' => '20M',
				'max_sp_recursion_depth' => '20',
				'optimizer_search_depth' => '0',
				'thread_stack' => '512K',
			},
		},
  }
}
