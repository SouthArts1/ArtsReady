require 'csv'

puts "Creating South Arts (Admin)"
org = Organization.create!(:name => 'South Arts', :address => '1800 Peachtree St., NW', :city => 'Atlanta', :state => 'GA', :zipcode => '30309', :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
admin = User.create!(:email=>'admin@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Admin', :last_name => 'User', :admin => true, :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)
admin = User.create!(:email=>'jlk@storiedfuture.com', :password => 'password', :password_confirmation => 'password', :first_name => 'JLK', :last_name => 'Test', :admin => true, :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)
admin = User.create!(:email=>'kmalone@southarts.org', :password => 'password', :password_confirmation => 'password', :first_name => 'Katy', :last_name => 'Malone', :admin => true, :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)

article = Article.create(:visibility=>'public', :organization => org, :user => admin, :title => 'Featuring ArtsReady', :body => 'Prepare for the unexpected', :description => 'Featured Introduction ArtsReady', :critical_function => 'technology', :featured => true)
article = Article.create(:visibility=>'public', :organization => org, :user => admin, :title => 'Paying for ArtsReady?', :body => 'Paying', :description => 'Paying for Preparedness', :critical_function => 'finances')

puts "Creating Fractured Atlas"
org = Organization.create!(:name => 'Fractured Atlas', :address => '248 W. 35th Street', :city => 'New York', :state => 'NY', :zipcode => '10001', :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'test@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Test', :last_name => 'User', :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)
member = User.create!(:email=>'kirsten.nordine@fracturedatlas.org', :password => 'password', :password_confirmation => 'password', :first_name => 'Kirsten', :last_name => 'Nordine', :organization => org, :title => 'tester', :accepted_terms => true)
member = User.create!(:email=>'justin.karr@fracturedatlas.org', :password => 'password', :password_confirmation => 'password', :first_name => 'Justin', :last_name => 'Karr', :organization => org, :title => 'tester', :accepted_terms => true)

puts "Adding some public articles"
member.articles.create(:title => 'First Article is Public and Feature', :body => 'This is my article', :visibility => 'public', :featured => true, :critical_function => 'people')
member.articles.create(:title => 'Another Public Article', :body => 'This is another article', :visibility => 'public', :critical_function => 'exhibits')

puts "Creating battle buddies"
org = Organization.create!(:name => 'Lincoln Center', :address => '10 Lincoln Center Plaza', :city => 'New York', :state => 'NY', :zipcode => '10023', :battle_buddy_enabled => true, :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'lc@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Lincoln', :last_name => 'Center', :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)

org = Organization.create!(:name => 'Whitney Museum of American Art', :address => '945 Madison Avenue', :city => 'New York', :state => 'NY', :zipcode => '10021', :battle_buddy_enabled => true, :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'wmaa@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Whitney', :last_name => 'Museum', :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)

org = Organization.create!(:name => 'The Museum of Modern Art', :address => '11 West 53rd Street', :city => 'New York', :state => 'NY', :zipcode => '10019', :battle_buddy_enabled => true, :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'moma@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Moma', :last_name => 'Museum', :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)

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
25,Ready means you have multiple people at your organization who know how to get in touch with I.T. vendors (and are authorized through your contract with the vendor) in case of an emergency at your organization.,technology
26,Ready means your key people are able to work remotely.,technology
27,Ready means you have important onsite electronic documents/recordings stored in multiple safe offsite places.,technology
28,Ready means you have taken steps to keep your email server and website secure from cyber-attacks and hacking.,technology
29,"Ready means you have designated a place on the organization's website where crisis communications would be posted, and assigned responsibility for authoring/posting information.",technology
30,Ready means that more than one person can install or re-install software and operating systems/drivers onto your organization's computers in case one or more of the computers experiences a loss or glitch.,technology
31,"Ready means your productions are documented sufficiently that, if one or more of your key people were suddenly absent, the show could still go on.",productions
32,"Ready means you keep your current production schedule in such a way that it can be accessed, no matter what happens.",productions
33,"Ready means your current contracts with artists and vendors are stored in a way that they can be accessed, no matter what happens.",productions
34,"Ready means you have documented policies in place so that if one of your productions had to be suddenly delayed or cancelled, your staff can successfully negotiate the change.",productions
35,"Ready means if you tour or perform offsite, you have plans in case something occurs offsite (transportation problems, medical issues, etc.).",productions
36,Ready means your phones have call forwarding so that you can receive calls at another location.,ticketing
37,"Ready means you keep your current events calendar in such a way that it can be altered for the public and internally, no matter what happens.",ticketing
38,Ready means you have a plan for how to sell tickets in the event that your current box office system fails.,ticketing
39,"Ready means your ticket refund policy is documented in such a way that audience members, employees and volunteers can easily understand it if an event changes/is cancelled.",ticketing
40,Ready means you have a current evacuation plan documented and posted.,facilities
41,Ready means volunteers and employees are trained/refreshed in evacuation procedures regularly.,facilities
42,"Ready means you have a facility preparation plan, and staff training, to protect and mitigate damage to your facility and assets in the event you have warning time before an event occurs.",facilities
43,"Ready means your most valuable assets (artwork, equipment, costumes/inventory) are stored in such a way as to minimize theft and damage.",facilities
44,Ready means your facilities have up-to-date emergency/safety equipment.,facilities
45,"Ready means you have tested and updated your building alarms (security, fire, smoke, etc.) in the last six months.",facilities
46,Ready means your local police and fire departments have toured your facilities recently and advised on security and fire protection.,facilities
47,Ready means a trusted employee or volunteer living close to your facility has copies of keys and alarm codes and is authorized to respond to emergency services.,facilities
48,"Ready means if you rent or receive donated space, your landlord has current information on who in your organization to contact in case of emergency.",facilities
49,Ready means you have a 'crisis kit' or cache of emergency supplies in your facility.,facilities
50,Ready means your facility has a functional emergency generator.,facilities
51,Ready means you have up to date agreements in place with a few Battle Buddies who can provide alternate facilities if yours becomes unavailable,facilities
52,"Ready means your programming is documented sufficiently so that, if one or more of your key people were suddenly absent, programming could still take place.",programs
53,Ready means you have a list of alternate suppliers/vendors to work with if your usual ones are not available.,programs
54,Ready means you have a planned process for making decisions about program budget cuts and alterations should they occur.,programs
55,Ready means you know how you would quickly communicate with the participants in your program(s) if you needed to.,programs
56,Ready means your documents and records pertaining to grants are adequately backed-up on a frequent basis.,grantmaking
57,"Ready means more than one person on your staff knows how to facilitate your grant application process, use your grantmaking database, or access your grantmaking files.",grantmaking
58,Ready means you have an adequate number of signatories authorized to award funds (in case one or more is suddenly not available).,grantmaking
59,Ready means you have a process to ensure grants can be paid if your organization experiences an emergency.,grantmaking
60,Ready means you have a process to determine how you will support constituent organizations/individuals in the event your community is impacted by a crisis.,grantmaking
61,"Ready means if your grants are awarded with pass-through funds and require your organization to provide reports to another funder, more than one person on staff knows your deadlines and the process for reporting your grantmaking activities.",grantmaking
62,"Ready means you have a plan for handling any changes to grant awards and communicating to grantees, if your budget were to decrease significantly and your grantmaking activities were jeopardized.",grantmaking
63,"Ready means your preparation for exhibits and the exhibit schedule (for either in-house or touring exhibits) is documented sufficiently that, if one or more of your key people were suddenly absent, the preparation could continue and the documents can be accessed off site",exhibits
64,Ready means you have a plan for accessing installation/de-installation materials should your organization's own tools become suddenly unavailable,exhibits
65,"Ready means your current contracts/loan agreements with artists, organizations, contractors and vendors and their contact information are kept in such a way that they can be accessed, no matter what happens.",exhibits
66,"Ready means you have documented policies in place so that if one of your exhibits had to be suddenly delayed or cancelled, your staff can successfully negotiate the delay/cancellation.",exhibits
67,"Ready means if you loan or rent your exhibits, you have plans in case something occurs offsite (transportation problems, damage documentation, ensuring adequate insurance coverage, etc.).",exhibits
68,Ready means you have the objects in your exhibit adequately documented/photographed upon installation in case they incur damage or get lost while in your care.,exhibits
69,"Ready means the value of the objects in the current exhibit has been accessed, documented, and could be easily obtained offsite.",exhibits
70,Ready means insurance is immediately updated upon the installation of a new exhibit or when a new object is acquired and multiple people can access records offsite.,exhibits
71,Ready means back up personnel understand the sensitivity and can handle the objects on display should the regular art handler become unavailable.,exhibits
72,Ready means you have an adequate (environmentally sensitive) back up site for emergency storage and clear instructions for their transport should your facility need to be evacuated of objects.,exhibits
END

CSV.parse(questions) do |row|
    Question.create(:import_id => row[0],:description => row[1], :critical_function => row[2])
end

puts "Loading the action items"
action_items = <<END
Update your organizational chart and upload to your Critical Stuff on ArtsReady.,1,
Update the stakeholder contact list and upload to your Critical Stuff on ArtsReady.,2,
"Update staff, board, and regular volunteer emergency contact lists and upload to your Critical Stuff on ArtsReady.",3,
Gather contracts and contact information for guest artists. Digitize the files and upload to your Critical Stuff on Arts Ready.,4,
Develop a phone and email tree (with external email addresses and phone numbers) for staff and other personnel. Upload to your Critical Stuff on ArtsReady.,5,
Document key responsibilities and functions for each staff member and place into a comprehensive 'Organization Guide' to be used in the event of a sudden absence. Upload the guide to your Critical Stuff on ArtsReady.,6,
Cross train staff in each other's key functions and tasks so a substitute can easily fill in case of sudden absence.,6,
Develop a clear interim and succession plan for the executive or organizational leader in the case of sudden absence. Document the plan in an 'Organization Guide' and upload to your Critical Stuff on ArtsReady.,7,
Research and list a few local counselors that specialize in workplace trauma.,8,
Develop a crisis communications plan and designate a media spokesperson and back up person for it.,9,
"Time to conduct workplace safety training! Work on response for one crisis or hazard pertinent to your facility (tornado, earthquake, OSHA safety procedures, etc).",10,12 months
Time practice evacuating staff from your facility! Be sure to also discuss and develop procedures for evacuating the public with your staff. Document and upload those procedures to your Critical Stuff on ArtsReady.,10,12 months
Time to check and refresh first aid kits in your facility! Make sure staff and volunteers know where they are,10,12 months
Time to do basic first aid and CPR training with staff and volunteers!,10,6 months
Designate and officiate back up signatories so funds can be accessed if the regular person becomes unavailable.,11,
Develop a safe way to store your daily cash intake at the close of business.,12,
Distill and digitize up-to-date financial records (including bank account numbers and quarterly balances). Upload the files to your Critical Stuff on ArtsReady.,13,
Train at least one back up person so they know how to access and read financial files in the case of a sudden absence.,13,
Set up on-line access with your bank(s) so you can conduct remote banking.,14,
Develop and document a plan for back-up compensation for staff.,15,
"Create an inventory of expensive electronics & equipment, include serial numbers and value. Digitize and upload the list to your Critical Stuff on ArtsReady.",16,
"Photograph or make a video of your facility and key equipment. Organize, clearly label, and back up the digital files.",16,
Time to contact your insurance agent! Make sure your coverage is up-to-date and includes any changes you've made recently.,17,12 months
"Upload your insurance company or agent's contact information, a copy of the policy(s), and the policy number(s) to your Critical Stuff on ArtsReady.",17,12 months
"Obtain an event insurance policy. Upload the providing company's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",18,
"Get insurance coverage for your new asset (or add it to your current policy). Upload the insurance company or agent's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",19,
Develop or update your GuideStar account.,20,
Organize your finances so restricted funds are in one or more separate accounts from general-use funds.,21,
"Cross train staff in the organization's computer systems. Provide necessary administrative privileges, passwords, and processes. Document passwords and necessary information and upload the file to your Critical Stuff on ArtsReady.",22,
"With adequate backups in place, simulate a power failure. Contact the appropriate IT and electrical personnel as needed prior to the test.",23,
Set up external servers with a host company to secure your digital files. Know the outside vendor's policy and protections for storage.,24,
Develop procedures for data back-up. Document the procedures and cross train staff on procedures.,24,
Document the contact information for your IT vendors and store the document on your Critical Stuff on ArtsReady. Inform pertinent staff and back up personal of information and any corresponding procedures.,25,
Set up remote access for key personnel. Confirm that all personnel have tested and can utilize the remote access.,26,
Set up multiple offsite storage systems for important online documents and recordings.,27,
"Confirm and document antivirus, spyware, spam filters, and firewall protections for computer systems. Include serial numbers in the documentation, and create an automatic renewal with the vendors that provide those protections.",28,
Designate a place on the website for emergency communications. Select and train a point person and at least one back up person for those communications.,29,
Provide backup personnel with necessary administrative privileges and training so they can perform software/driver/system installation or re-installation on your computers if the usual person is suddenly absent.  ,30,
Organize computer installation disks and up-to-date serial numbers so they are easily accessible and easy to find by staff. Include renewal dates and number of licenses allowed where necessary.  ,30,
Update the production procedures. Cross train staff in key positions of each production in case the usual person becomes suddenly absent.,31,
Update the production schedule and make it readily available on the organization's website and/or in your Critical Stuff on ArtsReady.,32,
Digitize contracts for artists in each production. Make them readily accessible and back them up on an external server.,33,
Develop and document policies for changing or substituting the production schedule to compensate for a delay or cancellation. Train staff in the policies.,34,
"Secure the necessary insurance (worker's compensation, auto insurance, etc.) for touring productions. Digitize and upload policy information to your Critical Stuff on ArtsReady.",35,
Develop and document policies for changing or substituting a touring production to compensate for a delay or cancellation. Train staff in the policies.,35,
Designate an alternate location or phone number for call forwarding. Make an arrangement for a Battle Buddy to act as a communication proxy as needed.,36,
Set up remote access for the internal events calendar so it can be updated both internally and publically.,37,
Develop a back up and/or offline system for box office sales should the current system fail. Cross train staff in the backup system.,38,
Develop and clearly document a refund policy for the public in case an event gets cancelled. Train staff and volunteers in refund protocols.,39,
Develop and post an evacuation plan. Make sure all staff and volunteers are aware of its locations.,40,
Time practice evacuating the public your facility! Be sure to also discuss and develop procedures for evacuating the public with your staff. Document and upload those procedures to your Critical Stuff on ArtsReady.,41,
Develop a facility shut down and prep plan for cases of advanced warning. Designate tasks in the plan to at least one staff member and a backup person who have appropriate accesses.,42,
Secure the most valuable assets in your organization in a well-protected place. Designate access to at least one trusted staff member and backup person.,43,
"Time to check emergency safety equipment! This includes fire alarms, extinguishers, carbon monoxide alarms, humidity detectors, etc.",44,12 months
Update the organization's alarm systems. Document the security codes and passwords in your Critical Stuff on ArtsReady.,45,6 months
Set up a facility tour with the police and fire departments to gain security advice.,46,12 months
Designate a trusted employee or volunteer and backup person near the facility to have copies of all facility keys. The same person should also have access at home to hard and/or digital copies of alarm codes.,47,
Confer with the landlord of your space. Ensure that s/he has updated contact information for at least two of your organization's personnel and vice versa.,48,
Create or update at least one emergency kit. Notify all employees and volunteers of its location(s).,49,
Procure and test an emergency back-up generator for your facility. Cross train staff on its function as needed.,50,
Form or update your Battle Buddy relationships to ensure back-up facility agreements.,51,
Document the current programming schedule and cross train staff in each event's basic function.,52,
Locate and list backup vendors for mandatory supplies for you organization.,53,
Develop a priority list to prepare for any necessary cuts or budget adjustments to programming.,54,
Create and update a communication strategy for contacting program participants quickly. Document those procedures and current contact lists; upload to your Critical Stuff on ArtsReady.,55,
Update all documents pertaining to grants and backup digital copies off site.,56,
"Cross train at least one back up staff member in day-to-day grantmaking procedures, including any software used in the process. Ensure that person has the necessary accesses.",57,
Designate at least one potential signatory in case the usual signatory is not available.,58,
Develop an emergency payment process for grantees should the usual payment method become stalled.,59,
Create achievable guidelines for aiding your constituents and grantees should a community crisis occur. Cross train staff in those methods.,60,
"Cross train staff in payout requirements and procedures for pass-through funds, especially those requiring reports or forms. Document pertinent deadlines and procedures clearly and store in an accessible, digital location.",61,
Develop a plan for communicating with your grant recipients and/or applicants about any important changes in the budgets or awards. Create a backed-up and accessible contact list of them that includes phone and e-mail.,62,
"Document the current exhibit schedule and preparation protocol sheet(s). Backup digitally, and make hard and soft copies accessible to all staff.",63,
Create a contingency plan for accessing backup tools or hardware needed for exhibit installation/de-installation.,64,
"Digitize contracts/loan agreements with artists, organizations, and contractors and backup on an external server. Include their contact information.",65,
Establish a policy for the delay/cancellation of an exhibit and back up the documentation on an external server.,66,
Create a contract template to be signed by borrowing organizations that details your policy regarding damaged pieces or exhibit loss. If necessary develop a contingency plan for such a loss.,67,
Create condition reports to be filled out before and after the loan of an object to track any damage or wear that may occur.,67,
"Create a comprehensive database with the details about all exhibit pieces. Include dimensions, medium, and insurance value. Backup this file and make it accessible offsite.",68,
Make photographic documentation of all exhibit pieces. Organize and store on an offsite server. Link these photos to a comprehensive database that verbally describes the piece.,68,
Create or update existing protocol for acquiring new exhibits or pieces to include immediate comprehensive documentation and value assessment.,69,
"Get insurance coverage for your exhibits (or add it to your current policy). Upload the insurance company or agent's contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.",70,
"Cross train staff in handling exhibit pieces, in case the usual person is suddenly absent. Include special notations for especially delicate objects.",71,
Make a 'priority list' that designates which objects should be considered most immediate for facility evacuation. Make the list readily accessible to staff.,72,
"Develop and document transportation requirements, and make an emergency storage plan with a Battle Buddy if sensitive objects need to evacuate your facility quickly.",72,
Locate and list alternate storage and transportation facilities in and out of region that could be utilized for emergency storage/shipment of sensitive objects. Be sure to find the appropriate environmental controls as needed.,72,
END

CSV.parse(action_items) do |row|
  q = Question.find_by_import_id(row[1])
  q.action_items.create(:description => row[0], :import_id => row[1], :recurrence => row[3])
end

puts "Creating pages"
pages = ['About','Staff','Tour','FAQ','Get ArtsReady','Give ArtsReady','List of current subsidizers','Useful Links','Site Map','Support ArtsReady','Contact Us','Press Center','ArtsReady How To', 'Privacy', 'Terms']
pages.each do |page|
  Page.create(:title => page, :body => "#{page} content", :slug => page.gsub(' ','').underscore)
end

puts "Adding unapproved organization"
org = Organization.create!(:name => 'Unapproved Org', :address => '1505 Broadway', :city => 'New York', :state => 'NY', :zipcode => '10001', :active => false, :battle_buddy_enabled => false, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'unapproved@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Unapproved', :last_name => 'Org', :organization => org, :role => 'manager', :title => 'tester', :accepted_terms => true)

puts "Adding crisis organization"
org = Organization.create!(:name => 'Crisis Org', :address => '205 Broadway', :city => 'New York', :state => 'NY', :zipcode => '10001', :battle_buddy_enabled => false, :active => true, :organizational_status => 'TEST', :operating_budget => 'NOTHING')
member = User.create!(:email=>'crisis@test.host', :password => 'password', :password_confirmation => 'password', :first_name => 'Crisis', :last_name => 'Org', :organization => org)
org.crises.create(:description => 'some crisis', :user => member, :title => 'tester', :accepted_terms => true)
