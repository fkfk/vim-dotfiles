command Mixi :call <SID>MixiStart()

function! s:MixiStart()
  set nonu
  ruby mixi_run
endfunction

ruby << EOF
class Mixi
  def initialize(email, password, mixi_premium = false)
    require 'kconv'
    require 'rubygems'
    require 'mechanize'

    @email, @password, @mixi_premium =
      email, password, mixi_premium
    @agent = WWW::Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
  end

  def post(title, body)
    page = @agent.get 'http://mixi.jp/home.pl'
    form = page.forms[0]
    form.email = @email
    form.password = @password
    @agent.submit form

    page = @agent.get "http://mixi.jp/home.pl"
    page = @agent.get page.links[18].uri
    form = page.forms[(@mixi_premium ? 1 : 0)]
    form.diary_title = title
    form.diary_body = self.class.magic_body(body)
    page = @agent.submit form
    page = @agent.submit page.forms[0]
  end

  def get_latest
    page = @agent.get 'http://mixi.jp/list_diary.pl'
    ["http://mixi.jp/" << page.links[35].uri.to_s.toutf8,
     page.links[35].text.toutf8]
  end

  def self.magic_body(body)
    body.gsub(/^(  )+/) {|i| '　'.toeuc * (i.length/2) }
  end
end

def mixi_run
  return if VIM.evaluate('confirm("really?")') == 0

  endline = VIM.evaluate %[line("$")]
  title   = VIM.evaluate %[getline(1)]
  body    = VIM.evaluate %[join(getline(2, #{endline}), "\n")]

  m = Mixi.new 'YOUR_EMAIL', 'YOUR_PASSWORD'
  # if you are mixi premium member:
  # m = Mixi.new 'YOUR_EMAIL', 'YOUR_PASSWORD', true
  m.post title.toeuc, body.toeuc
  m.get_latest.each do |line|
    VIM.evaluate %[append(#{endline}, \"#{line.chomp}\")]
  end
end
EOF
