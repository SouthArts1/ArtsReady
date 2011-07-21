require 'csv'

puts "South Arts"
org = Organization.create!(:name => 'South Arts', :address => '1800 Peachtree St., NW', :city => 'Atlanta', :state => 'GA', :zipcode => '30309', :active => true)
admin = User.create!(:email=>'admin@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Admin', :last_name => 'User', :admin => true, :organization => org)

article = Article.create(:visibility=>'public', :organization => org, :user => admin, :title => 'What is ArtsReady?', :body => 'Prepare for the unexpected', :description => 'Introduction ArtsReady')

puts "Creating Fractured Atlas"
org = Organization.create!(:name => 'Fractured Atlas', :address => '248 W. 35th Street', :city => 'New York', :state => 'NY', :zipcode => '10001', :active => true)
member = User.create!(:email=>'test@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Test', :last_name => 'User', :organization => org)
member = User.create!(:email=>'kirsten.nordine@fracturedatlas.org', :password => 'password', :password_confirmation => 'password', :first_name => 'Kirsten', :last_name => 'Nordine', :organization => org)
member = User.create!(:email=>'justin.karr@fracturedatlas.org', :password => 'password', :password_confirmation => 'password', :first_name => 'Justin', :last_name => 'Karr', :organization => org)

puts "Adding some public articles"
member.articles.create(:title => 'First Article is Public and Feature', :body => 'This is my article', :visibility => 'public')
member.articles.create(:title => 'Another Public Article', :body => 'This is another article', :visibility => 'public')

puts "Creating battle buddies"
org = Organization.create!(:name => 'Lincoln Center', :address => '10 Lincoln Center Plaza', :city => 'New York', :state => 'NY', :zipcode => '10023', :active => true, :battle_buddy_enabled => true)
member = User.create!(:email=>'lc@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Lincoln', :last_name => 'Center', :organization => org)

org = Organization.create!(:name => 'Whitney Museum of American Art', :address => '945 Madison Avenue', :city => 'New York', :state => 'NY', :zipcode => '10021', :active => true, :battle_buddy_enabled => true)
member = User.create!(:email=>'wmaa@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Whitney', :last_name => 'Museum', :organization => org)

org = Organization.create!(:name => 'The Museum of Modern Art', :address => '11 West 53rd Street', :city => 'New York', :state => 'NY', :zipcode => '10019', :active => true, :battle_buddy_enabled => true)
member = User.create!(:email=>'moma@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Moma', :last_name => 'Museum', :organization => org)

org = Organization.create!(:name => 'Fractured Atlas', :address => '248 West 35th Street', :city => 'New York', :state => 'NY', :zipcode => '10001', :active => true, :battle_buddy_enabled => false)
member = User.create!(:email=>'fa@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Fractured', :last_name => 'Atlas', :organization => org)

puts "Adding unapproved organization"
org = Organization.create!(:name => 'Unapproved Org', :address => '1505 Broadway', :city => 'New York', :state => 'NY', :zipcode => '10001', :active => false, :battle_buddy_enabled => false)
member = User.create!(:email=>'unapproved@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Unapproved', :last_name => 'Org', :organization => org)

puts "Loading the questions"
questions = <<END
1,"Ready means you keep your organizational chart in such a way that it can be accessed, no matter what happens.",people
2,Ready means your stakeholder contact lists are recently updated and easily obtained from offsite.,people
3,"Ready means you have current, accessible, in-case-of-emergency contact information for all staff, board and regular volunteers.",people
4,Ready means you collect contact information for all contract/guest artists and store it so it's accessible from offsite.,people
5,"Ready means you have an established phone/email tree, including alternate web-based email accounts, to contact key individuals in case of emergency.",people
6,Ready means you have documented key responsibilities and provided cross training on critical functions where a staff member's sudden absence would cause serious difficulties.,people
7,Ready means you have an emergency succession plan in place for your executive/leadership position.,people
8,Ready means you know how to obtain counseling for your staff if needed.,people
9,"Ready means you have a designated media spokesperson, backup person and a crisis communications plan for handling media and stakeholder relations during a crisis.",people
10,Ready means you regularly conduct workplace safety training including evacuation and first aid procedures.,people
11,Ready means you have an adequate number of signatories authorized to spend funds (in case one or more is suddenly not available).,finance
12,"Ready means if you collect significant amounts of cash, you have a safe location in which to secure them at the end of your event/workday.",finance
13,"Ready means your financial records are accessible (and understandable) to more than one person (including bank statements, accounts receivable, accounts payable and payroll).",finance
14,Ready means you are able to conduct remote banking.,finance
15,Ready means you have a plan for how employees would be compensated during times of emergency.,finance
16,"Ready means you have recently taken and stored (offsite/online) photos/videos of your building, inventory and equipment for potential insurance claims.",finance
17,Ready means you consult annually with your insurance agent about coverage and other advice.,finance
18,Ready means you have an event insurance policy in place to offset costs/losses in the case of a disruption to your normal event schedule.,finance
19,"Ready means you regularly update your insurance coverage to reflect new items (e.g. equipment, supplies, acquisitions, de-accessioned artwork and borrowed artwork).",finance
20,Ready means your GuideStar profile is up to date so that potential donors can vet your organization.,finance
21,"Ready means restricted-use funds (e.g. grant monies, endowment) are kept in separate bank accounts from general use funds.",finance
22,"Ready means your organization's computer systems (administrative privileges, passwords and processes) are known to enough people, and this data is kept where people can access them, in times of disruption.",technology
23,"Ready means you have considered how power failure will impact your systems, and have tested to verify you can restart systems.",technology
24,"Ready means if you use outside vendors to host your website(s) and/or valuable digital data, you know what their policies are for backing up your data and keeping it safe.",technology
25,Ready means you have multiple people at your organization who know how to get in touch with I.T. vendors (and are authorized through your contract with the vendor) in case of an emergency at your organization,technology
26,Ready means your key people are able to work remotely.,technology
27,Ready means you have important onsite electronic documents/ recordings stored in multiple safe offsite places.,technology
28,Ready means you have taken steps to keep your email server and website secure from cyber-attacks and hacking.,technology
29,"Ready means you have designated a place on the organization's website where crisis communications would be posted, and assigned responsibility for authoring/posting information.",technology
30,"Ready means your productions are documented sufficiently that, if one or more of your key people were suddenly absent, the show could still go on.",productions
31,"Ready means you keep your current production schedule in such a way that it can be accessed, no matter what happens.",productions
32,"Ready means your current contracts with artists and vendors are stored in a way that they can be accessed, no matter what happens.",productions
33,"Ready means you have documented policies in place so that if one of your productions had to be suddenly delayed or cancelled, your staff can successfully negotiate the change.",productions
34,"Ready means if you tour or perform offsite, you have plans in case something occurs offsite (transportation problems, medical issues, etc.)",productions
35,Ready means your phones have call-forwarding so that you can receive calls at another location.,ticketing
36,"Ready means you keep your current events calendar in such a way that it can be altered for the public and internally, no matter what happens.",ticketing
37,Ready means you have a plan for how to sell tickets in the event that your current box office system fails.,ticketing
38,"Ready means your ticket refund policy is documented in such a way that audience members, employees and volunteers can easily understand it if an event changes/is cancelled.",ticketing
39,Ready means you have a current evacuation plan documented and posted.,facilities
40,Ready means volunteers and employees are trained/refreshed in evacuation procedures regularly.,facilities
41,"Ready means you have a facility preparation plan, and staff training, to protect and mitigate damage to your facility and assets in the event you have warning time before an event occurs.",facilities
42,"Ready means your most valuable assets (artwork, equipment, costumes/inventory) are stored in such a way as to minimize theft and damage.",facilities
43,Ready means your facilities have up-to-date emergency/safety equipment.,facilities
44,"Ready means you have tested and and updated your building alarms (security, fire, smoke, etc.) in the last six months.",facilities
45,Ready means your local police and fire departments have toured your facilities recently and advised on security and fire protection.,facilities
46,Ready means a trusted employee or volunteer living close to your facility has copies of keys and alarm codes and is authorized to respond to emergency services.,facilities
47,"Ready means if you rent or receive donated space, your landlord has current information on who in your organization to contact in case of emergency.",facilities
48,Ready means you have a 'crisis kit' or cache of emergency supplies in your facility.,facilities
49,Ready means your facility has a functional emergency generator.,facilities
50,Ready means you have up to date agreements in place with a few Battle Buddies who can provide alternate facilities if yours becomes unavailable,facilities
51,"Ready means your programming is documented sufficiently so that, if one or more of your key people were suddenly absent, programming could still take place.",programs
52,Ready means you have a list of alternate suppliers/vendors to work with if your usual ones are not available.,programs
53,Ready means you have a planned process for making decisions about program budget cuts and alterations should they occur.,programs
54,Ready means you know how you would quickly communicate with the participants in your program(s) if you needed to.,programs
55,Ready means your documents and records pertaining to grants are adequately backed-up on a frequent basis.,grantmaking
56,"Ready means more than one person on your staff knows how to facilitate your grant application process, use your grantmaking database, or access your grantmaking files.",grantmaking
57,Ready means you have an adequate number of signatories authorized to award funds (in case one or more is suddenly not available).,grantmaking
58,Ready means you have a process to ensure grants can be paid if your organization experiences an emergency.,grantmaking
59,Ready means you have a process to determine how you will support constituent organizations/individuals in the event your community is impacted by a crisis.,grantmaking
60,"Ready means if your grants are awarded with pass-through funds and require your organization to provide reports to another funder, more than one person on staff knows your deadlines and the process for reporting your grantmaking activities.",grantmaking
61,"Ready means you have a plan for handling any changes to grant awards and communicating to grantees, if your budget were to decrease significantly and your grantmaking activities were jeopardized.",grantmaking
62,"Ready means your preparation for exhibits and the exhibit schedule (for either in-house or touring exhibits) is documented sufficiently that, if one or more of your key people were suddenly absent, the preparation could continue and the documents can be accessed off site",exhibits
63,Ready means you have a plan for accessing installation/de-installation materials should your organization's own tools become suddenly unavailable,exhibits
64,"Ready means your current contracts/loan agreements with artists, organizations, contractors and vendors and their contact information are kept in such a way that they can be accessed, no matter what happens.",exhibits
65,"Ready means you have documented policies in place so that if one of your exhibits had to be suddenly delayed or cancelled, your staff can successfully negotiate the delay/cancellation.",exhibits
66,"Ready means if you loan or rent your exhibits, you have plans in case something occurs offsite (transportation problems, damage documentation, ensuring adequate insurance coverage, etc.)",exhibits
67,Ready means you have the objects in your exhibit adequately documented/photographed upon installation in case they incur damage or get lost while in your care,exhibits
68,"Ready means the value of the objects in the current exhibit has been accessed, documented, and could be easily obtained offsite",exhibits
69,Ready means insurance is immediately updated upon the installation of a new exhibit or when a new object is acquired and multiple people can access records offsite,exhibits
70,Ready means back up personnel understand the sensitivity and can handle the objects on display should the regular art handler become unavailable,exhibits
71,Ready means you have an adequate (environmentally sensitive) back up site for emergency storage and clear instructions for their transport should your facility need to be evacuated of objects,exhibits
END

CSV.parse(questions) do |row|
    Question.create(:import_id => row[0],:description => row[1], :critical_function => row[2])
end

puts "Loading the action items"
action_items = <<END
 Update your organizational chart and upload to your Critical Stuff on ArtsReady,1,people,
 Update the stakeholder contact list and upload to your Critical Stuff on ArtsReady,2,people,
" Update staff, board, and regular volunteer emergency contact lists and upload to your Critical Stuff on ArtsReady",3,people,
 Gather contracts and contact information for guest artists,4,people,
 Develop a phone and email tree (with external email addresses and phone numbers) for staff and other personnel,5,people,
 Document key responsibilities and functions for each staff member and place into a comprehensive 'Organization Guide' to be used in the event of a sudden absence,6,people,
 Cross train staff in each other's key functions and tasks so a substitute can easily fill in case of sudden absence,6,people,
 Develop a clear interim and succession plan for the executive or organizational leader in the case of sudden absence,7,people,
 Research and list a few local counselors that specialize in workplace trauma,8,people,
 Designate a media spokesperson and back up person for crisis communications,9,people,
" Time to conduct workplace safety training! Work on response for one crisis or hazard pertinent to your facility (tornado, earthquake,OSHA safety procedures, etc)",10,people,Annually
 Time practice evacuating your facility! Be sure to also discuss and develop procedures for evacuating the public with your staff,10,people,Annually
 Time to check and refresh first aid kits in your facility! Make sure staff and volunteers know where they are,10,people,Annually
 Time to do basic first aid and CPR training with staff and volunteers!,10,people,Biannually
Designate and officiate back up signatories so funds can be accessed if the regular person becomes unavailable.,11,finance,
Develop a safe way to store your daily cash intake at the close of business.,12,finance,
Distill and digitize up-to-date financial records (including bank account numbers and quarterly balances). Upload the files to your Critical Stuff on ArtsReady,13,finance,
Train at least one back up person so they know how to access and read financial files in the case of a sudden absence.,13,finance,
Set up on-line access with your bank(s) so you can conduct remote banking.,14,finance,
Develop and document a plan for back-up compensation for staff.,15,finance,
"Create an inventory of valuable equipment, include serial numbers and value. Digitize and upload the list to your critical stuff on ArtsReady.",16,finance,
Photograph or make a video of your facility and key equipment. Organize and clearly label the digital images in a folder. Save the file to your Critical Stuff on ArtsReady.,16,finance,
Time to contact your insurance agent! Make sure your coverage is up-to-date and includes any changes you've made recently.,17,finance,Annually
"Upload your insurance company or agent's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",17,finance,Annually
"Obtain an event insurance policy. Upload the providing company's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",18,finance,
"Get insurance coverage for your new asset (or add it to your current policy). Upload the insurance company or agent's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",19,finance,
Develop or update your GuideStar account.,20,finance,
Organize your finances so restricted funds are in one or more separate accounts from general-use funds.,21,finance,
END

CSV.parse(action_items) do |row|
  q = Question.find_by_import_id(row[1])
  q.action_items.create(:description => row[0], :import_id => row[1], :recurrence => row[3])
end
