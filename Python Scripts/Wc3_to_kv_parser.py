##import ConfigParser


##NOTE: Files must have an empty line at the end
endline = '\t}\n\n'
class wc3pars:
    def __init__(self, section):
        self.npc_name = ''
        if 'Name' in section:
            self.npc_name = section['Name']
        
        self.baseclass = 'npc_dota_creature'
        self.level = 1
        self.ability1 = ''
        self.ability2 = ''
        self.ability3 = ''
        self.ability4 = ''
        
        self.armorphys = 0
        self.armormagic = 0
        
        self.attackcapabilities = 'DOTA_UNIT_CAP_MELEE_ATTACK'
        self.attackdamagemin = 7
        self.attackdamagemax = 8
        self.attackdamagetype = 'DAMAGE_TYPE_ArmorPhysical'
        self.attackrate = 1
        self.attackanimationpoint = .467
        self.attackacqurange = 500
        self.attackrange = 100

        self.projectilemodel = ''
        self.projectilespeed = ''

        self.bountyxp = 0
        if 'goldRep' in section:
            self.bountyxp = section['goldRep']
        self.bountygoldmin = 4
        self.bountygoldmax = 6

        self.statushealth= 365
        self.statushealthregen = 0
        if 'regenHP' in section:
            self.statushealthregen = section['regenHP']
        self.statusmana = 0
        self.statusmanaregen = 0
        if 'regenMana' in section:
            self.statusmanaregen = section['regenMana']

        self.team = 'DOTA_TEAM_BADGUYS'
        self.combatclassattack = 'DOTA_COMBAT_CLASS_ATTACK_BASIC'
        self.combatclassdefend = 'DOTA_COMBAT_CLASS_DEFEND_BASIC'
        self.unitrelationshipclass = 'DOTA_NPC_UNIT_RELATIONSHIP_TYPE_DEFAULT'
        self.visiondaytimerange = 1800
        self.visionnighttimerange = 800

        self.movementcapabilities = 'DOTA_UNIT_CAP_MOVE_GROUND'
        self.movementspeed = 375
        self.movementturnrate = .5
        self.boundshullname = 'DOTA_HULL_SIZE_HERO'
        self.healthbaroffset = 140

        self.comments = ''

    def check(self):
        print(self.npc_name)
        print(self.bountyxp)
        print(self.statushealthregen)
        print(self.statusmanaregen)

    def writetofile(self, nfile, write):  ##if you need to edit the format or spelling or whatever, do it here
        newfile = open(nfile, write)
        lines = []
        section = ''
        lines.append('\n')
        lines.append(self.kline(self.npc_name))
        lines.append(self.kvline('BaseClass', self.baseclass,None))
        lines.append(self.kvline('Level', self.level, None))
        lines.append(self.kvline('Ability1',self.ability1, None))
        lines.append(self.kvline('Ability2',self.ability2, None))
        lines.append(self.kvline('Ability3',self.ability3, None))
        lines.append(self.kvline('Ability4',self.ability4, None))
        lines.append(self.kvline('ArmorPhysical', self.armorphys, None))
        lines.append(self.kvline('MagicalResistance', self.armormagic, None))
        lines.append(self.kvline('AttackCapabilities',self.attackcapabilities, None))
        lines.append(self.kvline('AttackDamageMin', self.attackdamagemin, None))
        lines.append(self.kvline('AttackDamageMax', self.attackdamagemax, None))
        lines.append(self.kvline('AttackDamageType', self.attackdamagetype, None))
        lines.append(self.kvline('AttackRate', self.attackrate, None))
        lines.append(self.kvline('AttackAnimationPoint',self.attackanimationpoint, None))
        lines.append(self.kvline('AttackRage',self.attackrange, None))
        lines.append(self.kvline('ProjectileModel', self.projectilemodel, 'Add projectile models'))
        lines.append(self.kvline('ProjectileSpeed', self.projectilespeed, None))
        lines.append(self.kvline('BountyXP', self.bountyxp, None))
        lines.append(self.kvline('BountyGoldMin', self.bountygoldmin, None))
        lines.append(self.kvline('BountyGoldMax', self.bountygoldmax, None))
        lines.append(self.kvline('StatusHealth', self.statushealth, None))
        lines.append(self.kvline('StatusHealthRegen', self.statushealthregen, None))
        lines.append(self.kvline('StatusMana', self.statusmana, None))
        lines.append(self.kvline('StatsMagaRegen', self.statusmanaregen, None))
        lines.append(self.kvline('TeamName', self.team, None))
        lines.append(self.kvline('CombatClassAttack', self.combatclassattack, None))
        lines.append(self.kvline('CombatClassDefned', self.combatclassdefend, None))
        lines.append(self.kvline('UnitRelationShipClass', self.unitrelationshipclass, None))
        lines.append(self.kvline('VisionDaytimeRange', self.visiondaytimerange, None))
        lines.append(self.kvline('VisionNighttimeRange', self.visionnighttimerange, None))
        lines.append(self.kvline('MovementCapabilities', self.movementcapabilities, None))
        lines.append(self.kvline('MovementSpeed', self.movementspeed, None))
        lines.append(self.kvline('MovementTurnRate', self.movementturnrate, None))
        lines.append(self.kvline('BoundsHullName', self.boundshullname, None))
        lines.append(self.kvline('HealthBarOffset', self.healthbaroffset, None))
        lines.append(endline)
        for line in lines:
            section += line
        newfile.write(section)

    def kvline(self, key, val, comment):
        key = str(key)
        val = str(val)
        line = '\t\t"' + key + '"\t'
        if len(key) < 6:
            line += '\t'
        if len(key) < 14:
            line += '\t'
        if len(key) < 22:
            line += '\t'
        line += '"' + val +'"'
        if comment is not None:
            line += '\t //' + comment
        line += '\n'
        return line

    def kline(self, unit_name):
        line = '\t"'+ unit_name +'"\t//unit_name\n' '\t{\n'
        return line
        

def parse_file_section(textsec):
    lines = {}
    counter = 0
    with open(textsec) as f:
        for line in f:
            pair = line[0:-1].split('=')
            if len(pair) == 2:
                lines[pair[0]] = pair[1]
    return lines

def parse_text_section(textsec):
    textsec = textsec.split('\n')
    lines = {}
    counter = 0
    for line in textsec:
        pair = line.split('=')
        if len(pair) == 2:
            lines[pair[0]] = pair[1]
    return lines

def sectionoff(textfile):
    sections = {}
    with open(textfile, 'r') as f:
        secname = ''
        sec = ''
        for line in f:
            if line[0:1] == '[':
                sections[secname] = sec
                secname = line
                secname = secname[1:-2]
                sec = ''
            else:
                sec += line
    return sections


if __name__ == '__main__':
    file = parse_file_section('druid_example.txt')
    fullfile = sectionoff('units_copy.txt')
    
    work = wc3pars(file)
    ##work.writetofile('parsed.txt', 'w')
    for key in fullfile:
        if key is not '':
            file = parse_text_section(fullfile[key])
            work = wc3pars(file)
        work.writetofile('parsed.txt', 'a')
    work.check()
