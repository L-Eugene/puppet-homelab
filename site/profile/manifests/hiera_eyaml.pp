class profile::hiera_eyaml {
  class { 'hiera': 
    hiera_version   => '5', 
    hiera5_defaults => { 'datadir' => 'data', 'data_hash' => 'yaml_data' }, 
    hierarchy       => [ 
      'name'          => 'Example yaml', 
      'paths'         => [ 
        'secure.eyaml', 
        'nodes/%{trusted.certname}.yaml', 
        'virtual/%{facts.virtual}.yaml', 
        'os/%{facts.os.family}.yaml', 
        'common.yaml', 
      ], 
      'lookup_key'    => 'eyaml_lookup_key', 
      'options'       => { 
        'pkcs7_private_key' => '/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem', 
        'pkcs7_public_key'  => '/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem', 
      } 
    ], 
    eyaml             => true, 
  } 
}
