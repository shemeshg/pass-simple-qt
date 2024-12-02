from string import Template

def initCapital(s):
    return s[0].upper() + s[1:]

class Prpt:
    field_type = ""
    p_name = ""
    is_constant = False
    p_default_val = """"""
    no_setval_in_src = False

    def __init__(self, field_type, p_name,p_default_val="""""", no_setval_in_src=False):
        self.field_type = field_type
        self.p_name = p_name
        self.p_default_val = p_default_val
        self.no_setval_in_src = no_setval_in_src
        
    def get_p_initCapital(self):
        return initCapital(self.p_name)

    def getQ_Property(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            t = Template("""
            Q_PROPERTY( ${field_type} $p READ $p CONSTANT)""")
            return t.substitute(p=p,
                field_type=field_type, p_capitalize=p_capitalize)

        else:
            t = Template("""
            Q_PROPERTY( ${field_type} $p READ $p WRITE set${p_capitalize} NOTIFY ${p}Changed)""")
            return t.substitute(p=p,
                field_type=field_type, p_capitalize=p_capitalize)

    def getQ_header_private(self):
        field_type = self.field_type
        p = self.p_name
        if self.is_constant:
            return ""
        else:
            t = Template("""
            ${field_type} m_$p;""")
            return t.substitute(p=p,
                field_type=field_type)                

    def getQ_header_signal(self):
        field_type = self.field_type
        p = self.p_name
        if self.is_constant:
            return ""
        else:
            t = Template("""
            void ${p}Changed();""")
            return t.substitute(p=p)

    def getQ_header_save_item(self):
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        t = Template("""
    void save${p_capitalize}(){
        settings.setValue("${p}", m_${p});
    };""")
        return t.substitute(p=p,p_capitalize=p_capitalize)

    def getQ_header_public(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            return ""
        else:
            if field_type == "QString":
                t = Template("""
                const QString ${p}() const;
                void set${p_capitalize}(const QString &${p});""")
                return t.substitute(p=p,p_capitalize=p_capitalize)
            elif field_type == "bool" or field_type == "int":
                t = Template("""
                ${field_type} ${p}() const { return m_${p}; };
                void set${p_capitalize}(const ${field_type} ${p});""")
                return t.substitute(p=p,p_capitalize=p_capitalize,field_type=field_type)            
            else:
                return ""

    def appWindowState(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if field_type == "QByteArray":   
            t = Template("""
    QByteArray app${p_capitalize}() const {
        return settings.value("app/${p}").toByteArray();
    }
    void setApp${p_capitalize}(const QByteArray &app${p_capitalize}){
        settings.setValue("app/${p}", app${p_capitalize});
    }            
""") 
            return t.substitute(p=p, p_capitalize=p_capitalize)
        if field_type == "bool":   
            t = Template("""
    bool app${p_capitalize}() const {
        return settings.value("app/${p}",true).toBool();
    }
    void setApp${p_capitalize}(const bool app${p_capitalize}){
        settings.setValue("app/${p}", app${p_capitalize});
    }         
""") 
            return t.substitute(p=p, p_capitalize=p_capitalize)


    def getQ_src_contr(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            return ""
        else:
            if field_type == "QString":
                t = Template("""
                m_${p} = settings.value("${p}", "").toString();""")
                return t.substitute(p=p)
            elif field_type == "bool":
                p_default = self.p_default_val
                t = Template("""
                m_${p} = settings.value("${p}", ${p_default}).toBool();""")
                return t.substitute(p=p,p_default=p_default)    
            elif field_type == "int":
                p_default = self.p_default_val
                t = Template("""
                m_${p} = settings.value("${p}", ${p_default}).toInt();""")
                return t.substitute(p=p,p_default=p_default)                    
            else:
                return ""

    def getQ_src_setter(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        ref_sign = "&"
        if field_type == "int" or field_type=="bool":
            ref_sign = ""
        setval_t = Template("""settings.setValue("${p}", m_${p});""")
        setval = setval_t.substitute(p=p)
        if self.no_setval_in_src:
            setval = ""
        if self.is_constant:
            return ""
        else:
            t = Template("""
void AppSettings::set${p_capitalize}(const ${field_type} ${ref_sign}${p})
{
    if (${p} == m_${p})
        return;
    m_${p} = ${p};
    ${setval}
    emit ${p}Changed();
}
""")
            return t.substitute(p=p,field_type=field_type,
                p_capitalize=p_capitalize,
                ref_sign=ref_sign,setval=setval)

# End class

def getQ_Properties():
    s=""
    for row in a:
        s = s + row.getQ_Property()
    return s

def getQ_header_privates():
    s=""
    for row in a:
        s = s + row.getQ_header_private()
    return s      

def getQ_header_signals():
    s=""
    for row in a:
        s = s + row.getQ_header_signal()
    return s    

def getQ_header_publics():
    s=""
    for row in a:
        s = s + row.getQ_header_public()
    return s   

def getQ_src_contrs():
    s=""
    for row in a:
        s = s + row.getQ_src_contr()
    return s      

def getQ_src_setters():
    s=""
    for row in a:
        s = s + row.getQ_src_setter()
    return s      
    
def getQ_header_save_items():
    s=""
    for row in a:
        if row.no_setval_in_src:
            s = s + row.getQ_header_save_item()
    return s    

def get_appWindowStates():
    s=""
    for row in appWindowStates:
        s = s + row.appWindowState()
    return s     

a = [
    Prpt("QString",'passwordStorePath'),
    Prpt("QString",'tmpFolderPath'),
    Prpt("QString",'gitExecPath'),
    Prpt("QString",'vscodeExecPath'),
    Prpt("QString",'autoTypeCmd'),
    Prpt("QString",'ctxSigner'),
    Prpt("QString",'fontSize'),
    Prpt("QString",'commitMsg'),
    Prpt("QString",'ddListStores'),
    Prpt("QString",'binaryExts'),
    Prpt("QString",'ignoreSearch'),
    Prpt("bool",'useClipboard',"false"),
    Prpt("bool",'allowScreenCapture',"false"),
    Prpt("bool",'doSign',"false"),
    Prpt("bool",'useMonospaceFont',"false"),
    Prpt("bool",'preferYamlView',"true"),   
    Prpt("bool",'useRnpMultiThread',"false"),

    Prpt("bool",'isFindMemCash',"false", True),
    Prpt("bool",'isFindSlctFrst',"false", True),
    Prpt("bool",'isShowPreview',"true", True),
    Prpt("int",'openWith',"0", True),

    #Prpt("bool",'useRnpgp',"false"),
    Prpt("QString",'rnpgpHome'),

    Prpt("bool",'rnpPassFromStdExec',"false"),
    Prpt("QString",'rnpPassStdExecPath'),

]   

p = Prpt("QString",'appVer')
p.is_constant = True
a.append(p)
    

appWindowStates = [
    Prpt("QByteArray","windowState"),
    Prpt("QByteArray","geometry"),
    Prpt("QByteArray","splitter"),
    Prpt("QByteArray","treeviewHeaderState"),
    Prpt("bool","isShowTree"),
]
"""
remarks
print(getQ_Properties())
print(getQ_header_privates())
print(getQ_header_signals())
print(getQ_header_publics())
print(getQ_src_contrs())
print(getQ_src_setters())
print (getQ_header_save_items())
"""

