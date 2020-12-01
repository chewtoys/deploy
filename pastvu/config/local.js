module.exports = function(config, appRequire) {
  const _ = appRequire('lodash');
  const lang = process.env.LANG;
  const module = process.env.MODULE;
  const domain = process.env.DOMAIN;
  if (module == 'app') {
    app_host = 'localhost';
  } else {
    app_host = 'app_' + lang;
  }

  _.merge(config, {
    env: 'production',
    servePublic: false,
    serveStore: false,
    lang: lang,
    admin: {
      email: 'support@pastvu.stage',
    },

    listen: {
      hostname: '',
      port: 3000,
    },
    uploader: {
      hostname: 'uploader',
      port: 3001,
    },
    downloader: {
      hostname: 'downloader',
      port: 3002,
    },
    client: {
      protocol: 'http',
      hostname: 'localhost',
      port: '',
    },
    core: {
      hostname: app_host,
      port: 3010,
    },
    api: {
      hostname: app_host,
      port: 3011,
    },

    storePath: '/store',
    sitemapPath: '/sitemap',
    sitemapGenerateOnStart: true,
    logPath: '/logs',

    serveLogAuth: {
      user: 'admin',
      pass: 'admin'
    },

    mongo: {
      connection: 'mongodb://mongo:27017/pastvu',
      pool: 10,
      poolDownloader: 2
    },
    mongo_api: {
      con: 'mongodb://mongo:27017/pastvu',
    },
    redis: {
      host: 'redis',
    },

    mail: {
            type: 'SMTP',
            host: 'mailcatcher',
            port: 1025,
    },

    });


  return config;
};
