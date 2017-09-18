{% if page.comments %}
<link rel="stylesheet" href="/gitalk/gitalk.css">
<script src="/gitalk/gitalk.min.js"></script>

<script>
var gitalk = new Gitalk({
  clientID: 'cb9d990636e84547cadb',
  clientSecret: '78036da2ca2985c3df477c76c407a120ae664368',
  repo: 'cosmeapp.github.com',
  owner: 'cosmeapp',
  id: '',
  title: '{{ page.title }}',
  body: '{{ page.permalink }}\n\n{{ page.title }}',
  labels: ['Gitalk'{% if page.tags and page.tags.length %}{% for tag in page.tags %},'{{ tag.name }}'{% endfor %}{% endif %}],
  admin: ['huixisheng'],
  distractionFreeMode: true
});

gitalk.render('gitalk-container');
</script>
{% endif %}
