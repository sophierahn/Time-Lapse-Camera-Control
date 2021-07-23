from tkinter import *
from tkcalendar import *

#Use this file to open a GUI. It can be used to visually schedule specific appointments and export those to a text file

#Opening the schedule file
scheduleFile = open(r"schedule.txt", "w")

#GUI formatting
ws = Tk()
ws.title("Python Guides")
ws.geometry("500x400")
ws.config(bg="#cd950c")

#Setting Variables
hour_string = StringVar()
min_string = StringVar()
last_value_sec = ""
last_value = ""
f = ('Times', 20)

#Function to display and export chosen dates and times
def display_msg():
    date = cal.get_date()
    m = min_sb.get() #this is actually the hour
    h = sec_hour.get()#this is the minute
    s = sec.get()
    if len(m) < 2:
        m = '0%s'%(m)
    if len(h) < 2:
        h = '0%s'%(h)
    if len(s) < 2:
        s = '0%s'%(s)

    t = f"Your appointment is booked for {date} at {m}:{h}:{s}."
    msg_display.config(text=t)
    str1 = '{date}  {hour}:{minute}:{second}\n'.format(date=date, hour=m, minute=h, second=s)
    print(str1)
    scheduleFile.write(str1)

#Adjustments to GUI output to improve usability
if last_value == "59" and min_string.get() == "0":
    hour_string.set(int(hour_string.get()) + 1 if hour_string.get() != "23" else 0)
    last_value = min_string.get()

if last_value_sec == "59" and sec_hour.get() == "0":
    min_string.set(int(min_string.get()) + 1 if min_string.get() != "59" else 0)
if last_value == "59":
    hour_string.set(int(hour_string.get()) + 1 if hour_string.get() != "23" else 0)
    last_value_sec = sec_hour.get()
#------------------------------------    
#Add similar adjustment so date rolls forward when the hour is taken past midnight
#------------------------------------


#Specific formatting instructions
fone = Frame(ws)
ftwo = Frame(ws)

fone.pack(pady=10)
ftwo.pack(pady=10)

cal = Calendar(
    fone,
    selectmode="day",
    year=2021,
    month=2,
    day=3
)
cal.pack()

min_sb = Spinbox(
    ftwo,
    from_=0,
    to=23,
    wrap=True,
    textvariable=hour_string,
    width=2,
    state="readonly",
    font=f,
    justify=CENTER
)
sec_hour = Spinbox(
    ftwo,
    from_=0,
    to=59,
    wrap=True,
    textvariable=min_string,
    font=f,
    width=2,
    justify=CENTER
)

sec = Spinbox(
    ftwo,
    from_=0,
    to=59,
    wrap=True,
    textvariable=sec_hour,
    width=2,
    font=f,
    justify=CENTER
)

min_sb.pack(side=LEFT, fill=X, expand=True)
sec_hour.pack(side=LEFT, fill=X, expand=True)
sec.pack(side=LEFT, fill=X, expand=True)

msg = Label(
    ws,
    text="Hour  Minute  Seconds",
    font=("Times", 12),
    bg="#cd950c"
)
msg.pack(side=TOP)

actionBtn = Button(
    ws,
    text="Book Appointment",
    padx=10,
    pady=10,
    command=display_msg
)
actionBtn.pack(pady=10)

msg_display = Label(
    ws,
    text="",
    bg="#cd950c"
)
msg_display.pack(pady=10)

ws.mainloop()

#Close schedule file
scheduleFile.close()
