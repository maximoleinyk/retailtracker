#!/bin/sh
exec ~/Tools/mongodb/bin/mongod --logpath ~/Tools/mongodb/data/mongodb.log --dbpath ~/Tools/mongodb/data/db --rest
