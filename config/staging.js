module.exports = function (config, appRequire) {
  const _ = appRequire('lodash')
  const secrets = appRequire('docker-secret').secrets
  const appHost = 'app_' + config.lang
  _.merge(config, {
    env: 'production',
    servePublic: false,
    serveStore: false,
    notifier: process.env.MODULE === 'notifier',
    primary: process.env.PRIMARY === 'true',
    admin: {
      email: 'support@pastvu.tk'
    },
    listen: {
      port: 3000
    },
    uploader: {
      hostname: 'uploader',
      port: 3001
    },
    downloader: {
      hostname: 'downloader',
      port: 3002
    },
    client: {
      protocol: process.env.PROTOCOL,
      hostname: process.env.DOMAIN,
      port: ''
    },
    core: {
      hostname: appHost,
      port: 3010
    },
    api: {
      hostname: appHost,
      port: 3011
    },
    storePath: '/store',
    sitemapPath: '/sitemap',
    sitemapGenerateOnStart: true,
    logPath: '/logs',
    serveLogAuth: {
      user: 'admin',
      pass: secrets.pastvu_log_pass
    },
    mongo: {
      connection: 'mongodb://mongo:27017/pastvu',
      pool: 10,
      poolDownloader: 2
    },
    mongo_api: {
      con: 'mongodb://mongo:27017/pastvu'
    },
    redis: {
      host: 'redis'
    },
    mail: {
      type: 'SMTP',
      host: 'mailcatcher',
      port: 1025
    },
    publicApiKeys: {
      yandexMaps: secrets.pastvu_yandex_api_key,
      googleMaps: secrets.pastvu_google_api_key
    }
  })
  return config
}
